prod_host_project_id = "test-host-prod"

non_prod_project_id = "test-host-non-prod"

prod_host_vpc_link = "test-prod-vpc-selflink"

non_prod_vpc_link = "test-non-prod-vpc-selflink"

onprem_dns_entries = [
  {
    domain = "corp1.example.com"
    name   = "corp1"
    target_name_servers = [
      {
        ipv4_address    = "192.168.0.56",
        forwarding_path = "default"
      }
    ],
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
  {
    domain = "corp2.example.com"
    name   = "corp2"
    target_name_servers = [
      {
        ipv4_address    = "192.168.0.57",
        forwarding_path = "default"
      }
    ],
    labels = {
      owner   = "foo1"
      version = "bar1"
    }
  }
]

network_self_links = []

gcp_dns_entries = [
  {
    domain                             = "gcp.corp1.example.com."
    name                               = "gcp-corp1"
    private_visibility_config_networks = ["exmaple.selflink1"]
    record_sets = [
      {
        name = "ns"
        type = "A"
        ttl  = 300
        records = [
          "127.0.0.1",
        ]
      }
    ]
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
  {
    domain                             = "gcp.corp2.example.com."
    name                               = "gcp-corp2"
    private_visibility_config_networks = ["exmaple.selflink2"]
    record_sets = [
      {
        name = "ns"
        type = "A"
        ttl  = 300
        records = [
          "127.0.0.2",
        ]
      }
    ]
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
]