resource "aws_subnet" "wafo_pub" {
  count = length(var.pub_sub)
  vpc_id            = aws_vpc.wafo_vpc.id
  cidr_block        = var.pub_sub[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"
  tags = {
    "Name" = "${var.name}-pub${var.ava_zone[count.index]}"
  }
}

resource "aws_subnet" "wafo_priweb" {
  count = length(var.web_sub)
  vpc_id            = aws_vpc.wafo_vpc.id
  cidr_block        = var.web_sub[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"
  tags = {
    "Name" = "${var.name}-priweb${var.ava_zone[count.index]}"
  }
}

resource "aws_subnet" "wafo_priwas" {
  count = length(var.was_sub)
  vpc_id            = aws_vpc.wafo_vpc.id
  cidr_block        = var.was_sub[count.index]
  availability_zone = "${var.region}${var.ava_zone[count.index]}"
  tags = {
    "Name" = "${var.name}-priwas${var.ava_zone[count.index]}"
  }
}

resource "aws_subnet" "wafo_redis" {
  vpc_id            = aws_vpc.wafo_vpc.id
  cidr_block        =  var.redis_sub[0]
  availability_zone = "${var.region}${var.ava_zone[0]}"
  tags = {
    "Name" = "${var.name}-redis${var.ava_zone[0]}"
    }
}