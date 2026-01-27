module "GCS" {
  source = "./modules/gcs"
  labels = var.labels

  bucket_location = var.bucket_location
  random_id_byte_length = var.random_id_byte_length 

}

module vpc {
  source = "./modules/vpc"
  labels = var.labels

  vpc_region = var.vpc_region
  vpc_cidr   = var.vpc_cidr
}

module firewall {
  source = "./modules/firewall_allow_myip_only"
  labels = var.labels
  depends_on = [ module.vpc ]

  firewall_name = "${var.labels["builder"]}-allow-admin-access" 
  vpc_name =  module.vpc.output.name
}


module "gce" {
  source = "./modules/gce"
  labels = var.labels
  depends_on = [ module.firewall ]

  gce_name = var.gce_name
  gce_type = var.gce_type
  gce_image = var.gce_image
  gce_machine_type = var.gce_machine_type
  gce_subnet = module.vpc.output.public_subnet_self_link
  gce_region = var.vpc_region
  gce_zone = var.gce_zone
}

