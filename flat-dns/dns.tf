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

module "onprem-dns-forwarding-zone" {
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each                           = { for zone in var.onprem_dns_zones : zone.name => zone }
  name                               = each.value.name
  domain                             = each.value.domain
  labels                             = each.value.labels
  project_id                         = var.prod_host_project_id
  type                               = "forwarding"
  private_visibility_config_networks = [var.prod_host_vpc_link]
  target_name_server_addresses       = each.value.target_name_servers
}


module "onprem-dns-peering-zone" {
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each                           = { for zone in var.onprem_dns_zones : zone.name => zone }
  project_id                         = var.non_prod_project_id
  type                               = "peering"
  name                               = each.value.name
  domain                             = each.value.domain
  private_visibility_config_networks = [var.non_prod_vpc_link]
  target_network                     = var.prod_host_vpc_link
  labels                             = each.value.labels
  depends_on = [
    module.onprem-dns-forwarding-zone
  ]
}

module "gcp-dns-private-zone" {
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each                           = { for zone in var.gcp_dns_zones : zone.name => zone }
  project_id                         = each.value.project_id
  type                               = "private"
  name                               = each.value.name
  domain                             = each.value.domain
  labels                             = each.value.labels
  private_visibility_config_networks = each.value.private_visibility_config_networks
  recordsets                         = each.value.record_sets
}

module "gcp-dns-peering-zone" {
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each                           = { for peering in var.gcp_dns_peerings : peering.name => peering }
  project_id                         = each.value.project_id
  type                               = "peering"
  name                               = each.value.name
  domain                             = each.value.domain
  private_visibility_config_networks = each.value.private_visibility_config_networks
  target_network                     = each.value.target_network
  labels                             = each.value.labels
  depends_on = [
    module.gcp-dns-private-zone
  ]
}
