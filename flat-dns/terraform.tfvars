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

region = "asia-south1"

zone = "asia-south1-a"

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
