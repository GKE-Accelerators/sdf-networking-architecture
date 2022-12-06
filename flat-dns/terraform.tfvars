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

prod_host_project_id = "mineral-anchor-361313"

non_prod_project_id = "testm4cehost"

prod_host_vpc_link = "projects/mineral-anchor-361313/global/networks/test"

non_prod_vpc_link = "projects/testm4cehost/global/networks/default"

onprem_dns_zones = [
  {
    domain = "corp1.example.com."
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
    domain = "corp2.example.com."
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
  },
  {
    domain = "corp3.example.com."
    name   = "corp3"
    target_name_servers = [
      {
        ipv4_address    = "192.168.0.58",
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

gcp_dns_zones = [
  {
    domain                             = "prod.gcp.example.com."
    name                               = "prod-gcp"
    project_id                         = "mineral-anchor-361313"
    private_visibility_config_networks = ["projects/mineral-anchor-361313/global/networks/test"]
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
    domain                             = "nonprod.gcp.example.com."
    name                               = "nonprod-gcp"
    project_id                         = "testm4cehost"
    private_visibility_config_networks = ["projects/testm4cehost/global/networks/default"]
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
  {
    domain                             = "dev.gcp.example.com."
    name                               = "dev-gcp"
    project_id                         = "testm4cehost"
    private_visibility_config_networks = ["projects/testm4cehost/global/networks/default"]
    record_sets = [
      {
        name = "ns"
        type = "A"
        ttl  = 300
        records = [
          "127.0.0.3",
        ]
      }
    ]
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
]


gcp_dns_peerings = [
  {
    domain                             = "prod.gcp.example.com."
    name                               = "prod-gcp-peering"
    project_id                         = "testm4cehost"
    target_network                     = "projects/mineral-anchor-361313/global/networks/test"
    private_visibility_config_networks = ["projects/testm4cehost/global/networks/default"]
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
  {
    domain                             = "nonprod.gcp.example.com."
    name                               = "nonprod-gcp-peering"
    project_id                         = "mineral-anchor-361313"
    target_network                     = "projects/testm4cehost/global/networks/default"
    private_visibility_config_networks = ["projects/mineral-anchor-361313/global/networks/test"]
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
  {
    domain                             = "dev.gcp.example.com."
    name                               = "dev-gcp-peering"
    project_id                         = "mineral-anchor-361313"
    target_network                     = "projects/testm4cehost/global/networks/default"
    private_visibility_config_networks = ["projects/mineral-anchor-361313/global/networks/test"]
    labels = {
      owner   = "foo"
      version = "bar"
    }
  },
]
