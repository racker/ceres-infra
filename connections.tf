provider "google" {
  credentials = "${file("../gcp-account.json")}"
  project     = "${var.project-name}"
  region      = "${var.region}"
}