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
  project_id      = var.project_id
  type            = "forwarding"
  name            = var.name
  domain          = var.domain
  client_networks = [module.vpc.self_link]
  forwarders      = { "10.0.1.1" = null, "1.2.3.4" = "private" }
}


/* Peering Zone */ 
module "dns-peering-zone" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  project_id      = var.project_id
  type            = "peering"
  name            = var.name
  domain          = var.domain
  client_networks = [module.vpc.self_link]
  peer_network    = module.vpc2.self_link
  
}


/* Private Zone */ 
module "dns-private-zone-prod" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/dns?ref=v18.0.0"
  project_id      = var.project_id
  type            = "private"
  name            = var.name
  domain          = var.domain
  client_networks = [module.vpc.self_link]
  recordsets = {
    "A localhost" = { ttl = 300, records = ["127.0.0.1"] }
  }
}
