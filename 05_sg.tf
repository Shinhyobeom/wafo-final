resource "aws_security_group" "sg_bastion" {
  name        = "${var.name}-sg-bastion"
  description = "sg for bastion"
  vpc_id      = aws_vpc.wafo_vpc.id

  ingress = [
    {
      description      = var.SSH
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = var.tcp
      cidr_blocks      = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    },
    {
      description = var.Jenkins
      from_port = var.port_jenkins
      to_port = var.port_jenkins
      protocol = var.tcp
      cidr_blocks = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    }
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    }
  ]

  tags = {
    Name = "${var.name}-sg-bastion"
  }
}

resource "aws_security_group" "sg_web" {
  name        = "${var.name}-sg-web"
  description = "sg for web"
  vpc_id      = aws_vpc.wafo_vpc.id

  ingress = [
    {
      description      = var.SSH
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = var.tcp
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_bastion.id]
      prefix_list_ids  = var.nul
      self             = var.nul
    },
    {
      description      = var.HTTP
      from_port        = var.port_web
      to_port          = var.port_web
      protocol         = var.tcp
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_alb.id]
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
      cidr_blocks = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    }
  ]

  tags = {
    Name = "${var.name}-sg-web"
  }
}

resource "aws_security_group" "sg_was" {
  name        = "${var.name}-sg-was"
  description = "sg for was"
  vpc_id      = aws_vpc.wafo_vpc.id

  ingress = [
    {
      description      = var.SSH
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = var.tcp
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.sg_bastion.id]
      prefix_list_ids  = var.nul
      self             = var.nul
    },
    {
      description      = var.tomcat
      from_port        = var.port_was
      to_port          = var.port_was
      protocol         = var.tcp
      cidr_blocks      = ["10.0.2.0/24","10.0.3.0/24"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = var.nul
      self             = var.nul
    },
  ]
  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    }
  ]

  tags = {
    Name = "${var.name}-sg-was"
  }
}

resource "aws_security_group" "sg_alb" {
  name        = "${var.name}-sg-alb"
  description = "sg for alb"
  vpc_id      = aws_vpc.wafo_vpc.id

  ingress = [
    {
      description      = var.HTTP
      from_port        = var.port_web
      to_port          = var.port_web
      protocol         = var.tcp
      cidr_blocks      = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    },
    {
      description      = var.tomcat
      from_port        = var.port_was
      to_port          = var.port_was
      protocol         = var.tcp
      cidr_blocks      = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
      self             = var.nul
    },
    {
      description      = var.HTTPS
      from_port        = var.port_https
      to_port          = var.port_https
      protocol         = var.tcp
      cidr_blocks      = [var.cidr_all]
      ipv6_cidr_blocks = [var.cidrv6_all]
      prefix_list_ids  = var.nul
      security_groups  = var.nul
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
    Name = "${var.name}-sg-alb"
  }
}

resource "aws_security_group" "sg_efs" {
    name = "${var.name}-sg-efs"
    description = "security group for efs"
    vpc_id = aws_vpc.wafo_vpc.id

    ingress = [
        {
            description = var.efs
            from_port = var.port_efs
            to_port = var.port_efs
            protocol = var.tcp
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_was.id]
            prefix_list_ids = var.nul
            self = var.nul
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks      = [var.cidr_all]
            ipv6_cidr_blocks = [var.cidrv6_all]
            prefix_list_ids  = var.nul
            security_groups  = var.nul
            self             = var.nul
        }
    ]

    tags = {
        Name = "${var.name}-sg-efs"
    }
}

resource "aws_security_group" "sg_redis" {
    name = "${var.name}-sg-redis"
    description = "security group for redis"
    vpc_id      = aws_vpc.wafo_vpc.id

    ingress = [
        {
            description      = var.Redis
            from_port        = var.port_redis
            to_port          = var.port_redis
            protocol         = var.tcp
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups    = [aws_security_group.sg_was.id]
            prefix_list_ids  = var.nul
            self             = var.nul
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = [var.cidr_all]
            ipv6_cidr_blocks = [var.cidrv6_all]
            security_groups = var.nul
            prefix_list_ids = var.nul
            self = var.nul
        }
    ]
    
    tags = {
        Name = "${var.name}-security-redis"
    }
}