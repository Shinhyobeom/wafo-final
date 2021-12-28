resource "aws_instance" "web" {
  ami = data.aws_ami.amzn.id
  instance_type = var.ins_type
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  availability_zone = "${var.region}${var.ava_zone[0]}"
  private_ip = "10.0.2.11"
  #iam_instance_profile = aws_iam_instance_profile.profile_web.name
  subnet_id = aws_subnet.wafo_priweb[0].id
  user_data =<<-EOF
  #!/bin/bash
  sudo su -
  sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
  systemctl restart sshd
  EOF
  
  tags = {
    "Name" = "${var.name}-web"
  }
}
/*
resource "aws_iam_instance_profile" "profile_web" {
  name = "profile-web"
  role = aws_iam_role.role_web.name
}

resource "aws_iam_role" "role_web" {
  name = "role-web"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy_web" {
  name = "policy-web"
  role = aws_iam_role.role_web.id

  policy = <<END
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": [
                "${aws_s3_bucket.wafo_log_bucket.arn}/*"
            ]
        }
    ]
}
END
}
*/

resource "aws_instance" "was" {
  ami = data.aws_ami.amzn.id
  instance_type = var.ins_type_t3
  key_name = var.key
  vpc_security_group_ids = [aws_security_group.sg_was.id]
  availability_zone = "${var.region}${var.ava_zone[0]}"
  private_ip = "10.0.4.11"
  subnet_id = aws_subnet.wafo_priwas[0].id
  user_data =<<-EOF
  #!/bin/bash
  sudo su -
  sed -i "s/#Port 22/Port 22/g" /etc/ssh/sshd_config
  systemctl restart sshd
  EOF
  tags = {
    "Name" = "${var.name}-was"
  }
}