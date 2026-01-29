resource "google_storage_bucket" "my_bucket" {
  name          = "${var.labels["builder"]}-gcs-${random_id.bucket_suffix.hex}"
  location      = var.bucket_location
  force_destroy = true

  labels = var.labels
}

