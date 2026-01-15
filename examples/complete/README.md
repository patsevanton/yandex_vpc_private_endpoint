# Complete Example

This example demonstrates all available configuration options for the `yandex_vpc_private_endpoint` module.

## Features

- Custom timeouts configuration
- DNS options with private DNS records enabled
- Labels for resource tagging
- Detailed resource descriptions

## Usage

1. Configure your Yandex Cloud credentials:

```bash
export YC_TOKEN="your-token"
export YC_CLOUD_ID="your-cloud-id"
export YC_FOLDER_ID="your-folder-id"
```

2. Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## What's Created

- VPC Network with description
- VPC Subnet in ru-central1-a zone
- VPC Private Endpoint with:
  - DNS options enabled
  - Custom labels
  - Timeout configuration
  - Specific subnet binding

## Outputs

- `private_endpoint_id` - ID of the created private endpoint
- `private_endpoint_status` - Current status
- `private_endpoint_created_at` - Creation timestamp

## Clean Up

```bash
terraform destroy
```
