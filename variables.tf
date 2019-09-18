variable "region" {
  type    = "string"
  default = "us-east1"
}

variable "data-node-count" {
  default = "2"
}

variable "meta-node-count" {
  default = "3"
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

variable "data-node-firewall" {
  type    = "string"
  default = "influxdb-data-node-firewall"
}

variable "data-node-source-ranges" {
  type = "list"
  default = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "130.211.0.0/22",
    "35.191.0.0/16",
    "71.197.161.176/32"
  ]
}