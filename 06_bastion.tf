data "aws_ami" "amzn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "wafo_bastion" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = var.ins_type
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  availability_zone      = "${var.region}${var.ava_zone[0]}"
  #private_ip             = "10.0.0.11"
  subnet_id              = aws_subnet.wafo_pub[0].id
  iam_instance_profile = "admin_role"
  user_data              = file("./bastion_key.sh")

  depends_on = [
    time_sleep.wait_bastion
  ]

  tags = {
    "Name" = "${var.name}-bastion"
  }
  root_block_device {
        volume_size = 30
  }
  credit_specification{
        cpu_credits = "unlimited"
  }
}

# Elastic IP 할당
resource "aws_eip" "wafo_bastion_ip" {
  vpc        = true
  instance   = aws_instance.wafo_bastion.id
  depends_on = [aws_internet_gateway.wafo_ig]
}

output "bastion_public_ip" {
  value = aws_eip.wafo_bastion_ip.public_ip
}