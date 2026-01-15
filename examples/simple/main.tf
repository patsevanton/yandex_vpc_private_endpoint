// Create network
resource "yandex_vpc_network" "example" {
  name = "example-network"
}

// Create subnet
resource "yandex_vpc_subnet" "example" {
  name           = "example-subnet"
  v4_cidr_blocks = ["10.0.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.example.id
}

// Create VPC Private Endpoint
module "private_endpoint" {
  source = "../../"

  name       = "simple-private-endpoint"
  network_id = yandex_vpc_network.example.id

  endpoint_address = {
    subnet_id = yandex_vpc_subnet.example.id
  }

  dns_options = {
    private_dns_records_enabled = true
  }

  labels = {
    environment = "test"
  }
}

output "endpoint_id" {
  value = module.private_endpoint.id
}
