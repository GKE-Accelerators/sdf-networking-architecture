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



variable "client_networks" {
  description = "List of VPC self links that can see this zone."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "description" {
  description = "Domain description."
  type        = string
  default     = "Terraform managed."
}

variable "dns_zones" {
  type = list(object({
    name       = string
    domain     = string
    forwarders = map(string)
  }))
  default = [
    {
      domain = "corp.example.com"
      name   = "corp"
      forwarders = {
              "10.0.1.1" = "default", "1.2.3.4" = "private"
         }
    }
  ]
}

variable "private_zones" {
  type = list(object({
    name            = string
    domain          = string
    project_id      = string
    client_networks = list(string)
    record_sets     = map(object({
        ttl     = optional(number, 300)
        records = optional(list(string))
        geo_routing = optional(list(object({
          location = string
          records  = list(string)
        })))
        wrr_routing = optional(list(object({
          weight  = number
          records = list(string)
        })))
      }))
  }))
}

variable "domain" {
  description = "Zone domain, must end with a period."
  type        = string
  default     = ""
}

variable "inbound_policy_name" {
  description = "Inbound Policy Name."
  type        = string
}

variable "enable_logging" {
  description = "Enable query logging for this zone. Only valid for public zones."
  type        = bool
  default     = false
  nullable    = false
}

variable "forwarders" {
  description = "Map of {IPV4_ADDRESS => FORWARDING_PATH} for 'forwarding' zone types. Path can be 'default', 'private', or null for provider default."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Zone name, must be unique within the project."
  type        = string
  default     = ""
}

variable "peer_network" {
  description = "Peering network self link, only valid for 'peering' zone types."
  type        = string
  default     = null
}

variable "prod_host_project_id" {
  description = "Project id for the zone."
  type        = string
}

variable "non_prod_host_project_id" {
  description = "Project id for the zone."
  type        = string
}

variable "recordsets" {
  description = "Map of DNS recordsets in \"type name\" => {ttl, [records]} format."
  type = map(object({
    ttl     = optional(number, 300)
    records = optional(list(string))
    geo_routing = optional(list(object({
      location = string
      records  = list(string)
    })))
    wrr_routing = optional(list(object({
      weight  = number
      records = list(string)
    })))
  }))
  default  = {}
  nullable = false
  validation {
    condition = alltrue([
      for k, v in coalesce(var.recordsets, {}) :
      length(split(" ", k)) == 2
    ])
    error_message = "Recordsets must have keys in the format \"type name\"."
  }
  validation {
    condition = alltrue([
      for k, v in coalesce(var.recordsets, {}) : (
        (v.records != null && v.wrr_routing == null && v.geo_routing == null) ||
        (v.records == null && v.wrr_routing != null && v.geo_routing == null) ||
        (v.records == null && v.wrr_routing == null && v.geo_routing != null)
      )
    ])
    error_message = "Only one of records, wrr_routing or geo_routing can be defined for each recordset."
  }
}

variable "type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering', 'service-directory','reverse-managed'."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "forwarding", "peering", "service-directory", "reverse-managed"], var.type)
    error_message = "Zone must be one of 'public', 'private', 'forwarding', 'peering', 'service-directory','reverse-managed'."
  }
}

variable "zone_create" {
  description = "Create zone. When set to false, uses a data source to reference existing zone."
  type        = bool
  default     = true
}

variable "region" {
  type = string
}

