resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.alltags}-rtb-private"
  }
}

resource "aws_route" "route" {
  route_table_id = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = var.network_interface_id
}

resource "aws_route_table_association" "rtb_association" {
  subnet_id = var.subnet_id
  route_table_id = aws_route_table.route_table.id
}
