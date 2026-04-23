###cloud vars


variable "cloud_id" {
  type        = string
  description = "b1g98nk37d2anoqnj3ve"
}

variable "folder_id" {
  type        = string
  description = "b1gri0u5vvnbua2jgf6l"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "metadata" {
  type = map(string)

  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKc2F7ooAGyfrE2hwDm3XpJ5fWwgacar71R5hPK8PAv8 ppg@ELK"
  }
}
###ssh vars
