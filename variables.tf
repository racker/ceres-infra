variable "region" {
  type    = "string"
  default = "us-east1"
}

variable "zone" {
  type = "map"
  default = {
    "a" = "a"
    "b" = "b"
    "c" = "c"
  }
}

variable "project-name" {
  type    = "string"
  default = "ceres-dev-222017"
}

variable "vm-type" {
  type = "map"
  default = {
    "n1-standard-1"  = "n1-standard-1"
    "n1-standard-2"  = "n1-standard-2"
    "n1-standard-16" = "n1-standard-16"
    "n1-standard-32" = "n1-standard-32"
  }
}

variable "persistent-disk-type" {
  type    = "string"
  default = "pd-ssd"
}

variable "os" {
  type = "map"
  default = {
    "debian9" = "debian-cloud/debian-9"
  }
}