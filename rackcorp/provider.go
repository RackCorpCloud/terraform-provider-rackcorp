package rackcorp

import (
	"context"

	"github.com/hashicorp/terraform-plugin-log/tflog"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	api "github.com/rackcorpcloud/rackcorp-api-go"
)

func Provider() *schema.Provider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"api_uuid": {
				Type:        schema.TypeString,
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("RACKCORP_API_UUID", nil),
				Description: "The API UUID provided by Rackcorp.",
			},
			"api_secret": {
				Type:        schema.TypeString,
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("RACKCORP_API_SECRET", nil),
				Description: "The API secret provided by Rackcorp.",
				Sensitive:   true,
			},
			"customer_id": {
				Type:        schema.TypeString,
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("RACKCORP_CUSTOMER_ID", nil),
				Description: "Your Rackcorp Customer ID.",
			},
		},

		ResourcesMap: map[string]*schema.Resource{
			"rackcorp_server": resourceRackcorpServer(),
		},

		ConfigureContextFunc: providerConfigure,
	}
}

func providerConfigure(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
	client, err := api.NewClient(d.Get("api_uuid").(string), d.Get("api_secret").(string))
	if err != nil {
		return nil, diag.FromErr(err)
	}
	client.SetDebugLog(func(message string) {
		tflog.Debug(ctx, message)
	})

	config := providerConfig{
		Client:     client,
		CustomerID: d.Get("customer_id").(string),
	}

	return config, nil
}

type providerConfig struct {
	Client     api.Client
	CustomerID string
}
