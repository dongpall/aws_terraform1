provider "aws" {
  region = "ap-northeast-2"
}

module "main_vpc" {
  source = "../module/vpc"

  vpc_cidr = var.vpc_cidr
  alltags = var.alltags  
}

# public_subnet_rtb
module "pub_subnet" {
  source = "../module/subnet"

  vpc_id = module.main_vpc.main_vpc_id
  subnet_cidr = var.pub_subnet_cidr
  subnet_az = data.aws_availability_zones.available.names["${var.public_subnet_az}"]
  is_public = true

  alltags = var.alltags
}

module "igw" {
  source = "../module/igw"

  vpc_id = module.main_vpc.main_vpc_id
  
  alltags = var.alltags
}

module "pub_rtb" {
  source = "../module/pub_rtb"

  vpc_id = module.main_vpc.main_vpc_id
  igw_id = module.igw.igw_id
  subnet_id = module.pub_subnet.subnet_id

  alltags = var.alltags
}

# private_subnet_rtb
module "pri_subnet" {
  source = "../module/subnet"

  vpc_id = module.main_vpc.main_vpc_id
  subnet_cidr = var.pri_subnet_cidr
  subnet_az = data.aws_availability_zones.available.names["${var.private_subnet_az}"]
  is_public = false

  alltags = var.alltags
}

module "network_interface" {
  source = "../module/net_itf"

  subnet_id = module.pub_subnet.subnet_id
  sg_id = [module.nat_sg.sg_id]
  alltags = var.alltags
}

module "pri_rtb" {
  source = "../module/pri_rtb"

  vpc_id = module.main_vpc.main_vpc_id
  network_interface_id = module.network_interface.network_interface_id
  subnet_id = module.pri_subnet.subnet_id

  alltags = var.alltags
}

# SG
module "pri_sg" {
  source = "../module/SG"
  name = "private"
  vpc_id = module.main_vpc.main_vpc_id
  
  in_from_port = 0
  in_to_port = 65535
  in_protocol = "tcp"
  in_cidr_blocks = [module.main_vpc.vpc_cidr]

  e_from_port = 0
  e_to_port = 0
  e_protocol = "-1"
  e_cidr_blocks = ["0.0.0.0/0"]
}

module "pub_sg" {
  source = "../module/SG"
  name = "public"
  vpc_id = module.main_vpc.main_vpc_id
  
  in_from_port = 0
  in_to_port = 65535
  in_protocol = "tcp"
  in_cidr_blocks = ["0.0.0.0/0"]

  e_from_port = 0
  e_to_port = 0
  e_protocol = "-1"
  e_cidr_blocks = ["0.0.0.0/0"]
}

module "nat_sg" {
  source = "../module/SG"
  name = "nat"
  vpc_id = module.main_vpc.main_vpc_id
  
  in_from_port = 0
  in_to_port = 0
  in_protocol = "-1"
  in_cidr_blocks = [module.main_vpc.vpc_cidr]

  e_from_port = 0
  e_to_port = 0
  e_protocol = "-1"
  e_cidr_blocks = ["0.0.0.0/0"]
}

# instance
module "pri_instance" {
  source = "../module/instance"
  ami = var.windows_2016
  instance_type = var.t2_micro
  security_groups = [module.pri_sg.sg_id]
  subnet_id = module.pri_subnet.subnet_id
  key_name = var.key_name
  name = "pri"
}

module "pub_instance" {
  source = "../module/instance"
  ami = var.windows_2016
  instance_type = var.t2_micro
  security_groups = [module.pub_sg.sg_id]
  subnet_id = module.pub_subnet.subnet_id
  key_name = var.key_name
  name = "pub"
}

module "nat_instance" {
  source = "../module/nat_instance"
  ami = var.linux_2
  instance_type = var.t2_micro 
  key_name = var.key_name
  network_interface_id = module.network_interface.network_interface_id
  name = "nat"
}