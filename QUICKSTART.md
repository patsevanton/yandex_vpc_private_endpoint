# Quick Start Guide

## Prerequisites

1. Terraform >= 1.0
2. Yandex Cloud account
3. Yandex Cloud CLI configured or environment variables set

## Setup

### 1. Configure Yandex Cloud credentials

```bash
export YC_TOKEN="your-token"
export YC_CLOUD_ID="your-cloud-id"
export YC_FOLDER_ID="your-folder-id"
```

Or use `yc` CLI:

```bash
yc init
```

### 2. Use the module

Create a `main.tf` file:

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_vpc_network" "main" {
  name = "main-network"
}

resource "yandex_vpc_subnet" "main" {
  name           = "main-subnet"
  v4_cidr_blocks = ["10.0.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
}

module "private_endpoint" {
  source = "github.com/patsevanton/yandex_vpc_private_endpoint"

  name       = "my-private-endpoint"
  network_id = yandex_vpc_network.main.id

  endpoint_address = {
    subnet_id = yandex_vpc_subnet.main.id
  }

  dns_options = {
    private_dns_records_enabled = true
  }

  labels = {
    environment = "production"
  }
}

output "endpoint_id" {
  value = module.private_endpoint.id
}

output "endpoint_status" {
  value = module.private_endpoint.status
}
```

### 3. Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 4. Verify

```bash
# Check the private endpoint status
yc vpc private-endpoint get <endpoint-id>
```

## Next Steps

- See [examples/simple](./examples/simple/) for a minimal working example
- See [examples/complete](./examples/complete/) for all available options
- Read the [README.md](./README.md) for detailed documentation

## Cleanup

```bash
terraform destroy
```

## Troubleshooting

### Issue: "Error: Invalid provider configuration"

**Solution:** Make sure you have configured Yandex Cloud credentials:

```bash
yc config list
```

### Issue: "Error: network not found"

**Solution:** Ensure the network_id is correct and the network exists:

```bash
yc vpc network list
```

### Issue: "Error: subnet not found"

**Solution:** Verify the subnet exists and belongs to the specified network:

```bash
yc vpc subnet list
```

## Support

For issues and questions:
- Check the [official Yandex Cloud documentation](https://cloud.yandex.com/en/docs/vpc/concepts/private-endpoint)
- Open an issue on GitHub
