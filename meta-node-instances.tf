# Template to create InfluxDB Enterprise meta nodes.
resource "google_compute_instance_template" "meta-node-template" {
  name         = "meta-node-template"
  description  = "This template is used to create InfluxDB meta nodes."
  machine_type = "${var.vm-type.n1-standard-1}"

  disk {
    boot         = true
    auto_delete  = true
    source_image = "${var.os.debian9}"
  }

  network_interface {
    network = "default"
  }
}

# Create new meta node instances using the template
resource "google_compute_instance_from_template" "meta-node-instance" {
  count                    = "${var.meta-node-count}"
  name                     = "${var.meta-node-name-prefix}${count.index + 1}"
  zone                     = "${var.region}-${var.zone.b}"
  source_instance_template = "${google_compute_instance_template.meta-node-template.self_link}"

  metadata_startup_script = <<SCRIPT

wget https://dl.influxdata.com/enterprise/releases/influxdb-meta_1.7.8-c1.7.8_amd64.deb
sudo dpkg -i influxdb-meta_1.7.8-c1.7.8_amd64.deb

sudo sed -i 's/# hostname = ""/hostname = \"'`hostname`'\"/' /etc/influxdb/influxdb-meta.conf

sudo sed -i 's/# internal-shared-secret = ""/internal-shared-secret = "<SHARED_SECRET>"/' /etc/influxdb/influxdb-meta.conf

sudo sed -i 's/license-key = \"\"/license-key = "<LICENSE_KEY>"/' /etc/influxdb/influxdb-meta.conf

SCRIPT
}

output "meta-node-instances" {
  ## ${google_compute_instance_from_template.meta-node-instance.*.network_interface.network_ip}
  value = "${google_compute_instance_from_template.meta-node-instance.*.name}"
}