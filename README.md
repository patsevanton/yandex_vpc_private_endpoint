# yandex_vpc_private_endpoint

Terraform модуль для управления VPC Private Endpoint в Yandex Cloud.

## Описание

Этот модуль создает и управляет VPC Private Endpoint в Yandex Cloud. Приватные эндпоинты позволяют получать доступ к сервисам Yandex Cloud (например, Object Storage) из вашей VPC сети без использования публичного интернета.

## Быстрый старт

### Предварительные требования

1. Terraform >= 1.0
2. Аккаунт Yandex Cloud
3. Настроенный Yandex Cloud CLI или установленные переменные окружения

### Настройка

#### 1. Настройка учетных данных Yandex Cloud

```bash
export YC_TOKEN="your-token"
export YC_CLOUD_ID="your-cloud-id"
export YC_FOLDER_ID="your-folder-id"
```

Или используйте CLI `yc`:

```bash
yc init
```

#### 2. Использование модуля

Создайте файл `main.tf`:

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

#### 3. Развертывание

```bash
terraform init
terraform plan
terraform apply
```

#### 4. Проверка

```bash
# Проверка статуса приватного эндпоинта
yc vpc private-endpoint get <endpoint-id>
```

## Использование

См. директорию `examples/` для рабочих примеров.

### Базовый пример

```hcl
module "private_endpoint" {
  source = "github.com/patsevanton/yandex_vpc_private_endpoint"

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

### Полный пример

```hcl
module "private_endpoint" {
  source = "github.com/patsevanton/yandex_vpc_private_endpoint"

  name        = "object-storage-private-endpoint"
  description = "description for private endpoint"
  network_id  = yandex_vpc_network.lab-net.id
  folder_id   = "folder_id"

  endpoint_address = {
    subnet_id = yandex_vpc_subnet.lab-subnet-a.id
    address   = "10.2.0.10"  # Опционально: конкретный IP адрес
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

Дополнительные примеры см. в директории [examples](./examples/):
- [simple](./examples/simple/) - Базовое использование с минимальной конфигурацией
- [complete](./examples/complete/) - Полный пример со всеми опциями

## Требования

| Имя | Версия |
|------|---------|
| terraform | >= 1.0 |
| yandex | >= 0.100.0 |

## Входные параметры

| Имя | Описание | Тип | По умолчанию | Обязательный |
|------|-------------|------|---------|:--------:|
| name | Имя ресурса. | `string` | `null` | нет |
| description | Описание ресурса. | `string` | `null` | нет |
| network_id | ID сети, к которой принадлежит приватный эндпоинт. | `string` | n/a | да |
| folder_id | Идентификатор папки, к которой принадлежит ресурс. Если не указан, используется folder-id провайдера по умолчанию. | `string` | `null` | нет |
| labels | Набор пар ключ/значение меток, назначенных ресурсу. | `map(string)` | `{}` | нет |
| dns_options | Блок опций DNS приватного эндпоинта. | `object({ private_dns_records_enabled = bool })` | `null` | нет |
| endpoint_address | Блок спецификации адреса приватного эндпоинта. Может быть указан только один из вариантов: address_id или subnet_id + address. | `object({ subnet_id = optional(string), address = optional(string), address_id = optional(string) })` | `null` | нет |
| timeouts | Конфигурация таймаутов для операций создания, обновления и удаления. | `object({ create = optional(string), update = optional(string), delete = optional(string) })` | `null` | нет |

## Выходные параметры

| Имя | Описание |
|------|-------------|
| id | ID ресурса приватного эндпоинта. |
| name | Имя ресурса приватного эндпоинта. |
| description | Описание ресурса приватного эндпоинта. |
| network_id | ID сети, к которой принадлежит приватный эндпоинт. |
| folder_id | Идентификатор папки, к которой принадлежит ресурс. |
| labels | Набор пар ключ/значение меток, назначенных ресурсу. |
| status | Статус приватного эндпоинта. |
| created_at | Временная метка создания ресурса. |

## Примечания

- Блок `object_storage` всегда включен (требуется ресурсом) и пуст.
- Для `endpoint_address` может быть указана только одна из следующих комбинаций:
  - `address_id` (отдельно)
  - `subnet_id` + `address` (опционально)
  - `subnet_id` (отдельно)

## Удаление

```bash
terraform destroy
```

## Устранение неполадок

### Проблема: "Error: Invalid provider configuration"

**Решение:** Убедитесь, что вы настроили учетные данные Yandex Cloud:

```bash
yc config list
```

### Проблема: "Error: network not found"

**Решение:** Убедитесь, что network_id корректен и сеть существует:

```bash
yc vpc network list
```

### Проблема: "Error: subnet not found"

**Решение:** Проверьте, что подсеть существует и принадлежит указанной сети:

```bash
yc vpc subnet list
```

## Поддержка

По вопросам и проблемам:
- Проверьте [официальную документацию Yandex Cloud](https://cloud.yandex.com/en/docs/vpc/concepts/private-endpoint)
- Создайте issue на GitHub

## Авторы

Модуль поддерживается [Anton Patsev](https://github.com/patsevanton).

## Лицензия

MIT Licensed. См. [LICENSE](./LICENSE) для полной информации.
