resource "aws_vpc" "wafo_vpc_db" {
  cidr_block           = var.vpc_db_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "${var.name}-vpc_db"
  }
}


resource "aws_subnet" "wafo_pridb" {
  count = length(var.db_sub)
  vpc_id            = aws_vpc.wafo_vpc_db.id
  cidr_block        = var.db_sub[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"
  tags = {
    "Name" = "${var.name}-pridb"
  }
}

data "aws_caller_identity" "current" {}

##peering##
resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id = aws_vpc.wafo_vpc_db.id
  peer_owner_id = data.aws_caller_identity.current.id
  peer_vpc_id = aws_vpc.wafo_vpc.id
  auto_accept = true

  tags = {
    Name = "${var.name}-vpc-peering"
  }
  depends_on = [
    aws_vpc.wafo_vpc,
    aws_vpc.wafo_vpc_db
  ]

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "r1" {
  # ID of VPC 2 main route table.
  route_table_id = "${aws_vpc.wafo_vpc_db.main_route_table_id}"
  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${aws_vpc.wafo_vpc.cidr_block}"
  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}

resource "aws_route" "r2" {
  route_table_id = "${aws_vpc.wafo_vpc.main_route_table_id}"
  destination_cidr_block = "${aws_vpc.wafo_vpc_db.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}

resource "aws_route" "r3" {
  route_table_id = aws_route_table.wafo_rt.id
  destination_cidr_block = "${aws_vpc.wafo_vpc_db.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}

resource "aws_route" "r4" {
  route_table_id = aws_route_table.wafo_ngwrt.id
  destination_cidr_block = "${aws_vpc.wafo_vpc_db.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering.id}"
}


resource "aws_security_group" "sg_db" {
  name        = "${var.name}-sg-db"
  description = "sg for db"
  vpc_id      = aws_vpc.wafo_vpc_db.id

  ingress = [
    {
      description      = var.MySQL
      from_port        = var.port_mysql
      to_port          = var.port_mysql
      protocol         = var.tcp
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_was.id]
      prefix_list_ids  = var.nul
      self             = var.nul
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    }
  ]
  tags = {
    Name = "${var.name}-sg-db"
  }
}