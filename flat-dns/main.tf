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

data "google_compute_network" "prod_shared_vpc" {
  name    = var.prod_shared_vpc_name
  project = var.prod_host_project_id
}

data "google_compute_network" "nonprod_shared_vpc" {
  name    = var.nonprod_shared_vpc_name
  project = var.nonprod_host_project_id
}

/* Forwarding Zone */
module "dns-forwarding-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.forwarding_zones : zone.name => zone }
  project_id      = var.prod_host_project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = [data.google_compute_network.prod_shared_vpc.self_link]
  forwarders = {
    for ip_addr in each.value.target_server_ip_list :
    ip_addr => "private"
  }
  type = "forwarding"
}

/* Peering Zone */
module "dns-peering-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  for_each        = { for zone in var.forwarding_zones : zone.name => zone }
  project_id      = var.nonprod_host_project_id
  name            = each.value.name
  domain          = each.value.domain
  client_networks = [data.google_compute_network.nonprod_shared_vpc.self_link]
  peer_network    = data.google_compute_network.prod_shared_vpc.self_link
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

/* Inbound DNS Server Policy */
resource "google_dns_policy" "inbound" {
  project                   = var.prod_host_project_id
  name                      = var.inbound_policy_name
  enable_inbound_forwarding = true
  networks {
    network_url = data.google_compute_network.prod_shared_vpc.self_link
  }
  depends_on = [
    module.dns-forwarding-zone
  ]
}