# yandex_vpc_private_endpoint

Terraform module for managing Yandex Cloud VPC Private Endpoint.

## Description

This module creates and manages a VPC Private Endpoint within Yandex Cloud. Private endpoints allow you to access Yandex Cloud services (like Object Storage) from your VPC network without using public internet.

## Usage

### Basic Example

```hcl
module "private_endpoint" {
  source = "./modules/yandex_vpc_private_endpoint"

  name        = "object-storage-private-endpoint"
  description = "Private endpoint for Object Storage"
  network_id  = yandex_vpc_network.lab-net.id

  endpoint_address = {
    subnet_id = yandex_vpc_subnet.lab-subnet-a.id
  }

  dns_options = {
    private_dns_records_enabled = true
  }

  labels = {
    environment = "production"
    managed-by   = "terraform"
  }
}
```

### Complete Example

```hcl
module "private_endpoint" {
  source = "./modules/yandex_vpc_private_endpoint"

  name        = "object-storage-private-endpoint"
  description = "description for private endpoint"
  network_id  = yandex_vpc_network.lab-net.id
  folder_id   = "b1g1234567890abcdef"

  endpoint_address = {
    subnet_id = yandex_vpc_subnet.lab-subnet-a.id
    address   = "10.2.0.10"  # Optional: specific IP address
  }

  dns_options = {
    private_dns_records_enabled = true
  }

  labels = {
    my-label = "my-label-value"
  }

  timeouts = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| yandex | >= 0.100.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The resource name. | `string` | `null` | no |
| description | The resource description. | `string` | `null` | no |
| network_id | ID of the network which private endpoint belongs to. | `string` | n/a | yes |
| folder_id | The folder identifier that resource belongs to. If not provided, the default provider folder-id is used. | `string` | `null` | no |
| labels | A set of key/value label pairs which assigned to resource. | `map(string)` | `{}` | no |
| dns_options | Private endpoint DNS options block. | `object({ private_dns_records_enabled = bool })` | `null` | no |
| endpoint_address | Private endpoint address specification block. Only one of address_id or subnet_id + address arguments can be specified. | `object({ subnet_id = optional(string), address = optional(string), address_id = optional(string) })` | `null` | no |
| timeouts | Timeout configuration for create, update, and delete operations. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the private endpoint resource. |
| name | The name of the private endpoint resource. |
| description | The description of the private endpoint resource. |
| network_id | ID of the network which private endpoint belongs to. |
| folder_id | The folder identifier that resource belongs to. |
| labels | A set of key/value label pairs which assigned to resource. |
| status | Status of the private endpoint. |
| created_at | The creation timestamp of the resource. |

## Notes

- The `object_storage` block is always included (required by the resource) and is empty.
- For `endpoint_address`, only one of the following combinations can be specified:
  - `address_id` (standalone)
  - `subnet_id` + `address` (optional)
  - `subnet_id` (alone)

## License

This module is provided as-is.
