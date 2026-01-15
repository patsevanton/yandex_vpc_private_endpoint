// Create network
resource "yandex_vpc_network" "lab-net" {
  name        = "lab-network"
  description = "Network for private endpoint example"
}

// Create subnet
resource "yandex_vpc_subnet" "lab-subnet-a" {
  name           = "lab-subnet-a"
  description    = "Subnet for private endpoint"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab-net.id
}

// Create VPC Private Endpoint using the module
module "private_endpoint" {
  source = "../../"

  name        = "object-storage-private-endpoint"
  description = "Private endpoint for Object Storage"
  network_id  = yandex_vpc_network.lab-net.id

  endpoint_address = {
    subnet_id = yandex_vpc_subnet.lab-subnet-a.id
    # address   = "10.2.0.10"  # Optional: specific IP address
  }

  dns_options = {
    private_dns_records_enabled = true
  }

  labels = {
    environment = "development"
    managed-by  = "terraform"
    example     = "complete"
  }

  timeouts = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

// Outputs
output "private_endpoint_id" {
  description = "ID of the created private endpoint"
  value       = module.private_endpoint.id
}

output "private_endpoint_status" {
  description = "Status of the private endpoint"
  value       = module.private_endpoint.status
}

output "private_endpoint_created_at" {
  description = "Creation timestamp"
  value       = module.private_endpoint.created_at
}
