 module "onprem-dns-forwarding-zone" {
  source     = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each = {for entry in var.onprem_dns_entries:  entry.name => entry}
  name       = each.value.name
  domain     = each.value.domain
  labels     = each.value.labels
  project_id = var.prod_host_project_id
  type       = "forwarding"
  private_visibility_config_networks = [var.prod_host_vpc_link]
  target_name_server_addresses = each.value.target_name_servers
}


module "onprem-dns-peering-zone" {
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each = {for entry in var.dns_entries:  entry.name => entry}
  project_id                         = var.non_prod_project_id
  type                               = "peering"
  name                               = each.value.name
  domain                             = each.value.domain
  private_visibility_config_networks = [var.non_prod_vpc_link]
  target_network                     = var.prod_host_vpc_link
  labels                             = each.value.labels
}

module "gcp-dns-private-zone" {
  source     = "github.com/terraform-google-modules/terraform-google-cloud-dns"

 for_each = {for entry in var.gcp_dns_entries:  entry.name => entry}

  project_id = var.prod_host_project_id
  type       = "private"
  name       = each.value.name
  domain     = each.value.domain
  labels     = each.value.labels

  private_visibility_config_networks = [each.value.private_visibility_config_networks]

  recordsets = each.value.record_sets
}

module "gcp-dns-peering-zone" {
  source                             = "github.com/terraform-google-modules/terraform-google-cloud-dns"
  for_each = {for entry in var.gcp_dns_entries:  entry.name => entry}
  project_id                         = var.non_prod_project_id
  type                               = "peering"
  name                               = each.value.name
  domain                             = each.value.domain
  private_visibility_config_networks = [var.non_prod_vpc_link]
  target_network                     = var.prod_host_vpc_link
  labels                             = each.value.labels
}
