variable prod_host_project_id {
    type = string
    description = "Production host porject id"
}

variable prod_host_vpc_link {
    type = string
    description = "Production host porject vpc self link"
}

variable non_prod_vpc_link {
    type = string
    description = "Non Prod porject vpc self link"
}

variable "onprem_dns_entries" {
  type = list(object({
        name = string
        domain = string
        labels = map(any)
        target_name_servers = list(object({
            ipv4_address    = string,
            forwarding_path = string
        }))
  }))
#   default = [
#     {
#       domain             = "corp.example.com"
#       name               = "corp"
#       target_name_servers = [
#         {
#           ipv4_address    = "192.168.0.56",
#           forwarding_path = "default"
#         }
#       ],
#     }
#   ]
}

variable "network_self_links" {
  description = "Self link of the network that will be allowed to query the zone."
  default     = []
}

variable "gcp_private_zone_name" {
  description = "DNS zone name."
  default     = "foo-local"
}

variable "gcp_private_zone_domain" {
  description = "Zone domain."
  default     = "foo.local."
}

variable "labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default = {
    owner   = "foo"
    version = "bar"
  }
}

variable "record_sets" {
    type = list(object({
        name = string
        type = string
        ttl = number
        records = list(string)
  }))
  description = "Add the dns record sets to be added to the zone"
  default = [
    {
      name = "ns"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    }
  ]
}

variable "private_visibility_config_networks" {
  description = "Self link of the network that will be allowed to query the zone."
  default     = []
}


variable "gcp_dns_entries" {
  type = list(object({
        name = string
        domain = string
        labels = map(any)
        private_visibility_config_networks = list(string)
        record_sets = list(object({
            name = string
            type = string
            ttl = number
            records = list(string)
        }))
  }))
#   default = [
#     {
#       domain             = "gcp.corp.example.com"
#       name               = "corp"
#       private_visibility_config_networks = ["exmaple.selflink"]
#       record_sets = [
#         {
#             name = "ns"
#             type = "A"
#             ttl  = 300
#             records = [
#                 "127.0.0.1",
#             ]
#         }
#       ]   
#     },
#   ]
}