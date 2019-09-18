resource "google_compute_firewall" "influxdb-data-node-fw" {
  name    = "${var.data-node-firewall}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8086", "22"]
  }

  target_tags   = ["${var.data-node-firewall}"]
  source_ranges = "${var.data-node-source-ranges}"
}