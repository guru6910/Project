module "VPC" {
    source = "./module/vpc"
    vpc_cidr_block = var.vpc_cidr_block
    vpc_tag = var.vpc_tag
    subnet_cidr_block = var.subnet_cidr_block
    subnet_az = var.subnet_az
    map_public_ip_on_launch = var.map_public_ip_on_launch
    subnet_name = var.subnet_name
    igw_name = var.igw_name
    sg_name = var.sg_name
    ports = var.ports   
}

module "ec2" {
    source = "./Module/ec2"
    nginx_subnet_ids = module.VPC.nginx_subnet_ids
    tomcat_subnet_ids = module.VPC.tomcat_subnet_ids
    sg_id = module.VPC.sg_id
}