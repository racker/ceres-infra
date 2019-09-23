resource "google_compute_forwarding_rule" "load-balancer" {
  name                  = "load-balancer"
  backend_service       = "${google_compute_region_backend_service.lb-backend-service.self_link}"
  region                = "${var.region}"
  load_balancing_scheme = "INTERNAL"
  network               = "default"
  ip_protocol           = "TCP"
  ports                 = ["8086"]
}

resource "google_compute_region_backend_service" "lb-backend-service" {
  name          = "lb-backend-service"
  region        = "${var.region}"
  health_checks = ["${google_compute_health_check.lb-health-check.self_link}"]
  backend {
    group = "${google_compute_instance_group.influxdb-data-node-instances-group.self_link}"
  }
  connection_draining_timeout_sec = 10
}

resource "google_compute_health_check" "lb-health-check" {
  name                = "lb-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  tcp_health_check {
    port         = 8086
    proxy_header = "NONE"
    request      = ""
    response     = ""
  }
}

output "lb-ip-address" {
  value = "${google_compute_forwarding_rule.load-balancer.ip_address}"
}