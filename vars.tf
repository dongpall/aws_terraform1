data "aws_availability_zones" "available" {
  state = "available"
}

variable "vpc_cidr" {
  description = "VPC CIDR : x.x.x.x/x"
  default = "10.2.0.0/16"
}

variable "alltags" {
  description = "MY NAME"
  default = "dong"
}

variable "pub_subnet_cidr" {
  description = "PUB SUBNET CIDR : x.x.x.x/x"
  default = "10.2.50.0/24"
}

variable "public_subnet_az" {
  description = "PUB SUBNET AZ : 0(A)~3(D)"
  default = 0
}

variable "pri_subnet_cidr" {
  description = "PRI SUBNET CIDR : x.x.x.x/x"
  default = "10.2.150.0/24"
}

variable "private_subnet_az" {
  description = "PRI SUBNET AZ : 0(A)~3(D)"
  default = 2
}

variable "windows_2016" {
  description = "AMI : Microsoft Windows Server 2016 Base"
  default = "ami-072bd8e3146ac77da"
}

variable "t2_micro" {
  description = "Instance Type : t2.micro"
  default = "t2.micro"
}

variable "key_name" {
  description = "Key Name"
  default = "EC2_key"
}

variable "linux_2" {
  description = "AMI : Amazon Linux 2 AMI - Kernel 5.10, SSD Volume Type"
  default = "ami-0a0064415cdedc552"
}