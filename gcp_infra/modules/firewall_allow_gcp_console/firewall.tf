resource "google_compute_firewall" "allow_admin_access" {
  name    = var.firewall_name
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = [
    "35.235.240.0/20"                          
  ]
}