# allow all traffic for demo purpose
resource "google_compute_firewall" "allow_admin_access" {
  name    = var.firewall_name
  network = var.vpc_name 

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
}