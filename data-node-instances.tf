# Creates unmanaged instances group for InfluxDB Enterprise data nodes
resource "google_compute_instance_group" "influxdb-data-node-instances-group" {
  name    = "influxdb-data-node-instances-group"
  zone    = "${var.region}-b"

  instances = "${google_compute_instance_from_template.data-node-instance.*.self_link}"

  named_port {
    name = "tcp"
    port = "8086"
  }
}

# Template to create InfluxDB Enterprise data nodes.
resource "google_compute_instance_template" "data-node-template" {
  name         = "data-node-template"
  description  = "This template is used to create InfluxDB data nodes."
  machine_type = "${var.vm-type["n1-standard-16"]}"

  disk {
    boot         = true
    auto_delete  = true
    source_image = "${var.os["debian9"]}"
  }

  network_interface {
    network = "default"
  }
}

# Data node databases are stored on these SSD disk. Create as many disks as data nodes.
resource "google_compute_disk" "ssd-disk" {
  count = "${var.data-node-count}"
  name  = "test-influxdb-data-node-disk-${count.index + 1}"
  size  = 500
  type  = "${var.persistent-disk-type}"
  zone  = "${var.region}-b"
}

resource "google_compute_instance_from_template" "data-node-instance" {
  count                    = "${var.data-node-count}"
  name                     = "test-enterprise-data-0${count.index + 1}"
  zone                     = "${var.region}-b"
  source_instance_template = "${google_compute_instance_template.data-node-template.self_link}"

  attached_disk {
    source = "${google_compute_disk.ssd-disk.*.self_link[count.index]}"
  }

  metadata_startup_script = <<SCRIPT
echo "InfluxDB install starts" > /test.txt
wget https://dl.influxdata.com/enterprise/releases/influxdb-data_1.7.8-c1.7.8_amd64.deb
sudo dpkg -i influxdb-data_1.7.8-c1.7.8_amd64.deb
echo "InfluxDB install completed" >> /test.txt

SCRIPT
}

output "data-node-instances" {
  value = "${google_compute_instance_from_template.data-node-instance.*.self_link}"
}