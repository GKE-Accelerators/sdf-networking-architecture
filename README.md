# sdf-networking-architecture

## Introduction 
This architecture displays a use case where you have separate production and development environments that do not communicate with each other, but they share DNS servers.


## Architecture
![architecture diagram](https://raw.githubusercontent.com/GKE-Accelerators/sdf-networking-architecture/main/architecture_diagram.svg "Figure 1")


This is a flat dns architecture. As show in the diagram in the preceding section this architecture creates and configures the following resources
* Forwarding Zones
* Peering Zones
* Private Zones
* Inbound Server Policy


## Pre-requisites
The architecture assumes that the following configuration is already in place and will be dependent on these resources to work as expected.


**DNS Server Configuration**
- Configure your on-premises DNS servers to be authoritative for on-premises DNS zones. 

- Configure DNS forwarding (for GCP DNS names) targeting the Cloud DNS inbound forwarding IP address, which is created via the Inbound Server Policy in the Prod Shared VPC. This allows on-premises hosts to resolve Google Cloud DNS names via the Prod Shared VPC.

- Ensure that your on-premises firewall allows the queries from Cloud DNS IP address range 35.199.192.0/19. DNS uses UDP port 53 or TCP port 53, depending on the size of the request or response.

- Ensure that your DNS server does not block queries. If your on-premises DNS server accepts requests only from specific IP addresses, make sure that the IP range 35.199.192.0/19 is included.

**Shared VPC** 
- The architecture is based on the assumption that there is a shared Prod & Non Prod VPC already configured and is available and the account used to create the resources have all the required permissions required to deploy the components in the architecture.


## Components

### Forwarding Zone
* In this architecture we will designate the Prod Shared VPC as the network that will query the on-premises DNS servers and act as DNS hub.
* This blueprint will create a Cloud DNS forwarding zone in the Prod Host project targeting the on-premises DNS resolvers

### Peering Zone
* In this particular use case the  Non-Prod Shared VPC does not directly query the DNS servers on-premises and has to go through the Prod Shared VPC to access these DNS records.
* This blueprint will create a Cloud DNS peering zone in the Non-Prod Host project, for on-premises DNS names targeting the Prod Shared VPC as the peer network. This allows the resources in the non-prod network to resolve on-premises DNS names.

### Private Zone 
* Private zones enable you to manage custom domain names for your Google Cloud resources. In a Shared VPC configuration it is recommended to host all the private zones on Cloud DNS within the host project
* This blueprint will create a Prod DNS private zone (for example, prod.gcp.example.com) in the Prod Host project and attach it to the zone. Similarly it would create a Non-Prod DNS private zone (for example, dev.gcp.example.com) in the Non-Prod Host Project and attach Non-Prod Shared to the zone.
* This blueprint will create create a Cloud DNS peering zone in Non-Prod Host project for Prod DNS names targeting the Prod Shared VPC as the peer network. This configuration allows hosts (on-premises and all service projects) to resolve Prod DNS names.
* This blueprint will create create a Cloud DNS peering zone in Prod Host project for Non-Prod DNS names targeting the Non-Prod Shared VPC as the peer network. This allows hosts (on-premises and all service projects) to resolve the Non-Prod DNS names.

### Inbound Server Policy
* An inbound server policy is needed to enable on-premises DNS servers to send requests to Cloud DNS in Google Cloud.
* This blueprint will create an Inbound Server Policy in the Prod host project for the Prod Shared VPC network.


## LICENSE
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

`http://www.apache.org/licenses/LICENSE-2.0`

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

