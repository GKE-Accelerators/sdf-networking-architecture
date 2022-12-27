/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/* Forwarding Zone */ 
module "dns-forwarding-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.dns_zones : zone.name => zone }
  project_id      = var.prod_host_project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = [module.prod_vpc.self_link]
  forwarders      = each.value.forwarders
  type            = "forwarding"
}


/* Peering Zone */ 
module "dns-peering-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.dns_zones : zone.name => zone }
  project_id      = var.non_prod_host_project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = [ module.non_prod_vpc.self_link ]
  peer_network    = module.prod_vpc.self_link
  type            = "peering"
  depends_on = [
    module.dns-forwarding-zone
  ]
  
}

# /* Private Zone */ 
# module "dns-private-zone" {
#   source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
#   for_each        = { for zone in var.private_zones : zone.name => zone }
#   project_id      = each.value.project_id
#   name            = each.value.name
#   domain          = each.value.domain
#   client_networks = each.value.client_networks
#   recordsets      = each.value.record_sets  
#   type            = "private"
#   depends_on = [
#     module.dns-forwarding-zone,
#     module.dns-peering-zone
#   ]
# }

/* Prod Private Zone */
module "dns-prod-private-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.prod_private_zones : zone.name => zone }
  project_id      = each.value.project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = data.google_compute_network.prod_shared_vpc.self_link
  recordsets      = each.value.record_sets
  type            = "private"
  depends_on = [
    module.dns-forwarding-zone,
    module.prod-peering-zone
  ]
}


/* Prod Peering Zone */
module "prod-peering-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.prod_private_zones : zone.name => zone }
  project_id      = var.nonprod_host_project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = [data.google_compute_network.nonprod_shared_vpc.self_link]
  peer_network    = data.google_compute_network.prod_shared_vpc.self_link
  type            = "peering"
  depends_on = [
    module.dns-prod-private-zone
  ]
}


/* NonProd Private Zone */
module "dns-nonprod-private-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.nonprod_private_zones : zone.name => zone }
  project_id      = each.value.project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = data.google_compute_network.prod_shared_vpc.self_link
  recordsets      = each.value.record_sets
  type            = "private"
  depends_on = [
    module.dns-forwarding-zone,
    module.dns-peering-zone
  ]
}


/* NonProd Peering Zone */
module "nonprod-peering-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.nonprod_private_zones : zone.name => zone }
  project_id      = var.nonprod_host_project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = [data.google_compute_network.prod_shared_vpc.self_link]
  peer_network    = data.google_compute_network.nonprod_shared_vpc.self_link
  type            = "peering"
  depends_on = [
    module.dns-nonprod-private-zone
  ]
}


/* Inbound DNS Server Policy */ 
resource "google_dns_policy" "inbound" {
  project                   = var.prod_host_project_id
  name                      = var.inbound_policy_name
  enable_inbound_forwarding = true
  networks {
    network_url = module.prod_vpc.self_link
  }
  depends_on = [
    module.dns-forwarding-zone
  ]
}


/* Custom Cloud Router */ 
resource "google_compute_router" "router" {
  name    = "custom-router"
  project = var.prod_host_project_id
  network = module.prod_vpc.name
  region  = var.region
  bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = "35.199.192.0/19"
    }
  }

}
