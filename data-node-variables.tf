
variable "data-node-disk-prefix" {
  type    = "string"
  default = "test-influxdb-data-node-disk"
}

variable "data-node-disk-size" {
  default = "500"
}

variable "data-node-count" {
  default = "4"
}

variable "data-node-name-prefix" {
  type    = "string"
  default = "enterprise-data-0"
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