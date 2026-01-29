# --------------------------------------------------------
# infra project settings
# --------------------------------------------------------
region = "us-central1"
labels = {
    builder = "max"
    stage   = "dev"
    env     = "lab"
    source = "terraform_vault"
}

# --------------------------------------------------------
# GCS settings
# --------------------------------------------------------
random_id_byte_length = 4
bucket_location = "US"

# --------------------------------------------------------
# vpc settings
# --------------------------------------------------------
vpc_region = "us-central1"
vpc_cidr   = "10.0.0.0/16"

# --------------------------------------------------------
# gce settings
# --------------------------------------------------------
gce_name  = "gce-instance"
gce_type  = "public"
gce_image = "debian-cloud/debian-11"
gce_machine_type = "e2-micro"
gce_zone  = "a"



