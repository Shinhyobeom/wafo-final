resource "aws_internet_gateway" "wafo_ig" {
  vpc_id = aws_vpc.wafo_vpc.id

  tags = {
    "Name" = "${var.name}-ig"
  }
}

resource "aws_route_table" "wafo_rt" {
  vpc_id = aws_vpc.wafo_vpc.id

  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.wafo_ig.id
  }
  tags = {
    "Name" = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "wafo_igas_pub" {
  count = 2
  subnet_id      = aws_subnet.wafo_pub[count.index].id
  route_table_id = aws_route_table.wafo_rt.id
}