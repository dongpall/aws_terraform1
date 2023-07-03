resource "aws_instance" "nat_instance" {
  ami = var.ami
  instance_type = var.instance_type
  key_name =var.key_name
  

  network_interface {
    network_interface_id = var.network_interface_id
    device_index = 0
  }

    tags = {
    Name = "${var.name}_instance"
  }
  
    user_data = <<EOT
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
yum -y update
sysctl -w net.ipv4.ip_forward=1
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
yum install iptables-services
service iptables save
--//
  EOT

}