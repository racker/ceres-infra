# Creates unmanaged instances group for InfluxDB Enterprise data nodes
resource "google_compute_instance_group" "influxdb-data-node-instances-group" {
  name = "influxdb-data-node-instances-group"
  zone = "${var.region}-${var.zone.b}"

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
  machine_type = "${var.vm-type.n1-standard-16}"

  disk {
    boot         = true
    auto_delete  = true
    source_image = "${var.os.debian9}"
  }

  network_interface {
    network = "default"
  }
}

# Data node databases are stored on these SSD disk. Create as many disks as data nodes.
resource "google_compute_disk" "ssd-disk" {
  count = "${var.data-node-count}"
  name  = "${var.data-node-disk-prefix}-${count.index + 1}"
  size  = "${var.data-node-disk-size}"
  type  = "${var.persistent-disk-type}"
  zone  = "${var.region}-${var.zone.b}"
}

# Create new data node instances using the template
resource "google_compute_instance_from_template" "data-node-instance" {
  count                    = "${var.data-node-count}"
  name                     = "${var.data-node-name-prefix}${count.index + 1}"
  zone                     = "${var.region}-${var.zone.b}"
  source_instance_template = "${google_compute_instance_template.data-node-template.self_link}"

  attached_disk {
    source = "${google_compute_disk.ssd-disk.*.self_link[count.index]}"
  }

  metadata_startup_script = <<SCRIPT

wget https://dl.influxdata.com/enterprise/releases/influxdb-data_1.7.8-c1.7.8_amd64.deb
sudo dpkg -i influxdb-data_1.7.8-c1.7.8_amd64.deb

sudo sed -i 's/# hostname = "localhost"/hostname = \"'`hostname`'\"/' /etc/influxdb/influxdb.conf

sudo sed -i 's/license-key = \"\"/license-key = "<LICENSE KEY>"/' /etc/influxdb/influxdb.conf

sudo sed -i 's/# meta-auth-enabled = false/meta-auth-enabled = true/' /etc/influxdb/influxdb.conf

sudo sed -i 's/# meta-internal-shared-secret = ""/meta-internal-shared-secret = "<SHARED SECRET>"/' /etc/influxdb/influxdb.conf

sudo sed -i 's/# auth-enabled = false/auth-enabled = false/' /etc/influxdb/influxdb.conf

SCRIPT
}

output "data-node-instances" {
  value = "${google_compute_instance_from_template.data-node-instance.*.name}"
}