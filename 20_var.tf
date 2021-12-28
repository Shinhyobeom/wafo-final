variable "name" {
  type = string #타입 문자
  default = "wafo"
}

variable "region" {
  type = string #타입 문자
  default = "ap-northeast-2"
}

variable "key" {
  type = string
  default = "hb-key"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_db_cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "ava_zone" {
  type = list
  default = ["a","c"]
}

variable "pub_sub" {
  type = list
  default = ["10.0.0.0/24","10.0.1.0/24"]
}

variable "web_sub" {
  type = list
  default = ["10.0.2.0/24","10.0.3.0/24"]
}

variable "was_sub" {
  type = list
  default = ["10.0.4.0/24","10.0.5.0/24"]
}

variable "redis_sub" {
type = list
default = ["10.0.6.0/24"]
}

variable "db_sub" {
  type = list
  default = ["192.168.0.0/24","192.168.1.0/24"]
}

variable "cidr_all" {
  type = string
  default = "0.0.0.0/0"
}

variable "cidrv6_all" {
  type = string
  default = "::/0"
}

variable "nul" {
  default = null
}

variable "SSH" {
  type    = string
  default = "SSH"
}

variable "Jenkins" {
  type = string
  default = "Jenkins"
}

variable "HTTP" {
  type    = string
  default = "HTTP"
}

variable "tomcat" {
  type    = string
  default = "tomcat"
}

variable "HTTPS" {
  type    = string
  default = "HTTPS"
}

variable "MySQL" {
  type    = string
  default = "MySQL"
}

variable "efs" {
  type    = string
  default = "efs"
}

variable "Redis" {
  type    = string
  default = "Redis"
}

variable "tcp" {
  type    = string
  default = "tcp"
}

variable "pro_tcp" {
  type    = string
  default = "TCP"
}

variable "port_ssh" {
  type    = number
  default = 22
}

variable "port_jenkins" {
  type = number
  default = 60010
}

variable "port_web" {
  type    = number
  default = 80
}

variable "port_https" {
  type    = number
  default = 443
}

variable "port_was" {
  type    = number
  default = 8080
}

variable "port_mysql" {
  type    = number
  default = 3306
}

variable "port_efs" {
  type    = number
  default = 2049
}

variable "port_redis" {
  type    = number
  default = 6379
}

variable "ins_type" {
  type    = string
  default = "t2.micro"
}

variable "ins_type_t3" {
  type    = string
  default = "t3.medium"
}

variable "lb_type_app" {
  type    = string
  default = "application"
}

variable "lb_type_net" {
  type    = string
  default = "network"
}

variable "lb_tg_type" {
  type    = string
  default = "instance"
}

variable "db_storage" {
  type    = number
  default = 20
}

variable "db_type" {
  type    = string
  default = "gp2"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_v" {
  type    = string
  default = "8.0.23"
}

variable "db_ins_type" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type    = string
  default = "petclinic"
}

variable "db_identi" {
  type    = string
  default = "wafo"
}

variable "db_username" {
  type    = string
  default = "root"
}

variable "db_password" {
  type    = string
  default = "petclinic"
}

variable "s3_acl" {
  type    = string
  default = "public-read-write"
}

variable "device_name" {
  type    = string
  default = "/dev/sdh"
}

variable "lambda_email" {
  type    = string
  default = "spdhqjtl@gmail.com"
}

variable "redis_engine" {
  type    = string
  default = "redis"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t2.micro"
}

variable "bucket_name" {
  type = string #타입 문자
  default = "wafo-s3-bucket0815"
}

variable "ami" {
  type = string #타입 문자
  default = "ami-0263588f2531a56b"
}
