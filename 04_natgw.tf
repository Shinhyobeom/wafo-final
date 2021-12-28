#EIP 만들기
resource "aws_eip" "wafo_ngw_ip" {
  vpc = true
}
# NAT게이트웨이 만들기
resource "aws_nat_gateway" "wafo_ngw" {
  allocation_id = aws_eip.wafo_ngw_ip.id
  subnet_id     = aws_subnet.wafo_pub[0].id
  tags = {
    "Name" = "${var.name}-ngw"
  }
}

resource "aws_route_table" "wafo_ngwrt" {
  vpc_id = aws_vpc.wafo_vpc.id

  route {
    cidr_block = var.cidr_all
    gateway_id = aws_nat_gateway.wafo_ngw.id
  }
  tags = {
    "Name" = "${var.name}-ngwrt"
  }
}

resource "aws_route_table_association" "wafo_ngwass_priweb" {
  count = 2
  subnet_id      = aws_subnet.wafo_priweb[count.index].id
  route_table_id = aws_route_table.wafo_ngwrt.id
}

resource "aws_route_table_association" "wafo_ngwass_priwas" {
  count = 2
  subnet_id      = aws_subnet.wafo_priwas[count.index].id
  route_table_id = aws_route_table.wafo_ngwrt.id
}