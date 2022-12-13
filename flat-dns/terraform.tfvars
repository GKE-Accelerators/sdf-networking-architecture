/**
 * Copyright 2018 Google LLC
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


prod_host_project_id       = "PROD_HOST_PROJECT_ID"
non_prod_host_project_id   = "NON_PROD_HOST_PROJECT_ID"
inbound_policy_name        = "gcp-inbound"
region = "europe-west1"
dns_zones           = [
    {
        domain = "bar.local."
        name   = "bar"
        forwarders =  {
                "10.0.1.1" = "default", "1.2.3.4" = "private"
            }
    },
    {
        domain = "foo.example." 
        name   = "foo"
        forwarders =  {
                "192.168.0.57" = "default", "1.2.3.4" = "private"
            }
    }
]       

private_zones = [
  {
    domain             = "prod.gcp.example.com."
    name               = "prod"
    project_id         = "project-b-364018"
    client_networks   = ["projects/project-b-364018/global/networks/prod"]
    record_sets       = {
        "A localhost" = { records = ["127.0.0.1"] }
        "A myhost"    = { ttl = 600, records = ["10.0.0.120"] }
    }
  },
  {
    domain              = "dev.gcp.example.com."
    name                = "nonprod"
    project_id          = "project-c-364018"
    client_networks     = ["projects/project-c-364018/global/networks/test"]
    record_sets         = {
          "A localhost" = { records = ["127.0.0.1"] }
          "A myhost"    = { ttl = 550, records = ["10.0.0.120"] }
    }
  }
]


