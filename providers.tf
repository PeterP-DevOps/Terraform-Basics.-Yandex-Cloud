terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.12.0"
}

provider "yandex" {
  # token     = var.token
  cloud_id                 = "b1g98nk37d2anoqnj3ve"
  folder_id                = "b1g15ehoqojfquk256hr"
  zone                     = var.default_zone
  service_account_key_file = file("./authorized_key.json")

}
