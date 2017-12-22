terraform {
  required_providers {
    rackcorp = {
      source  = "rackcorp/rackcorp"
      version = "~> 0.1"
    }
  }
}

provider "rackcorp" {
  api_uuid    = "the-uuid-from-tf"
  api_secret  = "the-secret-from-tf"
  customer_id = "001122"
}

resource "rackcorp_server" "example" {
  country          = "the-country-from-tf"
  server_class     = "PERFORMANCE"
  operating_system = "the-operating-system-from-tf"
  cpu_count        = 1
  memory_gb        = 4
  root_password    = "a-secret-password"
  location         = "GLOBALSWITCH-SYD1"
  timezone         = "UTC"

  nic {
    name      = "public"
    vlan      = 1
    speed     = 1000
    ipv4      = 1
    #pool_ipv4 = 1
    ipv6      = 1
    #pool_ipv6 = 1
  }

  firewall_rule {
    direction       = "INBOUND"
    policy          = "ALLOW"
    protocol        = "TCP"
    port_to         = "80"
    port_from       = "80"
    ip_address_from = "192.0.2.5"
    ip_address_to   = "192.0.2.6"
    comment         = "HTTP"
    order           = 25
  }

  // data_center_id = 19

  // name = "the-hostname-from-tf"

  // post_install_script = "${file("a-script.sh")}"

  // traffic_gb = 10

  // host_group_id = 5

  storage {
    size_gb = 50
    type    = "SSD" // or MAGNETIC
  }

}
