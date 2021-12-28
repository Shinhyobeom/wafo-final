#DB생성
resource "aws_db_instance" "wafo_mydb" {
  allocated_storage      = var.db_storage
  storage_type           = var.db_type
  engine                 = var.db_engine
  engine_version         = var.db_engine_v
  instance_class         = var.db_ins_type
  name                   = var.db_name
  identifier             = var.db_identi
  username               = var.db_username
  password               = var.db_password
  availability_zone      = "${var.region}${var.ava_zone[0]}"
  #multi_az = true                    # 멀티 az
  db_subnet_group_name   = aws_db_subnet_group.wafo_dbsg.id
  vpc_security_group_ids = [aws_security_group.sg_db.id]
  skip_final_snapshot    = true
  backup_window          = "10:00-10:30"  #자동 백업이 생성되는 시간
  backup_retention_period = 4             #백업 보관 날짜
  apply_immediately      = true           #db 수정사항 즉시 적용
  tags = {
    "Name" = "${var.name}-db"
  }
}
#DB서브넷 그룹
resource "aws_db_subnet_group" "wafo_dbsg" {
  name       = "${var.name}-dbsg"
  subnet_ids = [aws_subnet.wafo_pridb[0].id, aws_subnet.wafo_pridb[1].id]
}
#스냅샷 생성
resource "aws_db_snapshot" "test" {
  db_instance_identifier = aws_db_instance.wafo_mydb.id
  db_snapshot_identifier = "testsnapshot1234"
}
# 자동 백업
/*resource "aws_db_instance" "backup" {
  instance_class      = "db.t2.micro"
  name                = "petclinic_backup"
  snapshot_identifier = data.aws_db_snapshot.test.id

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}
*/