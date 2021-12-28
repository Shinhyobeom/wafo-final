# 키 설정
resource "aws_key_pair" "hb_key" {
  key_name   = var.key
  public_key = file("../../.ssh/hb-key.pub")
}
