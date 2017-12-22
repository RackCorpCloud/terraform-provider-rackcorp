package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
	"github.com/rackcorpcloud/terraform-provider-rackcorp/rackcorp"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{ProviderFunc: rackcorp.Provider})
}
