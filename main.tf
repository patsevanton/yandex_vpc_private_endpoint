resource "yandex_vpc_private_endpoint" "this" {
  name        = var.name
  description = var.description
  network_id  = var.network_id
  folder_id   = var.folder_id

  labels = var.labels

  object_storage {}

  dynamic "dns_options" {
    for_each = var.dns_options != null ? [var.dns_options] : []
    content {
      private_dns_records_enabled = dns_options.value.private_dns_records_enabled
    }
  }

  dynamic "endpoint_address" {
    for_each = var.endpoint_address != null ? [var.endpoint_address] : []
    content {
      subnet_id  = try(endpoint_address.value.subnet_id, null)
      address    = try(endpoint_address.value.address, null)
      address_id = try(endpoint_address.value.address_id, null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
