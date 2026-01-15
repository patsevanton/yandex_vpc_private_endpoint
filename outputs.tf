output "id" {
  description = "The ID of the private endpoint resource."
  value       = yandex_vpc_private_endpoint.this.id
}

output "name" {
  description = "The name of the private endpoint resource."
  value       = yandex_vpc_private_endpoint.this.name
}

output "description" {
  description = "The description of the private endpoint resource."
  value       = yandex_vpc_private_endpoint.this.description
}

output "network_id" {
  description = "ID of the network which private endpoint belongs to."
  value       = yandex_vpc_private_endpoint.this.network_id
}

output "folder_id" {
  description = "The folder identifier that resource belongs to."
  value       = yandex_vpc_private_endpoint.this.folder_id
}

output "labels" {
  description = "A set of key/value label pairs which assigned to resource."
  value       = yandex_vpc_private_endpoint.this.labels
}

output "status" {
  description = "Status of the private endpoint."
  value       = yandex_vpc_private_endpoint.this.status
}

output "created_at" {
  description = "The creation timestamp of the resource."
  value       = yandex_vpc_private_endpoint.this.created_at
}
