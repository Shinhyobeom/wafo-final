resource "time_sleep" "wait_bastion" {
  depends_on = [aws_instance.web]

  create_duration ="1m"
}

resource "time_sleep" "wait_web" {
  depends_on = [aws_instance.web]

  create_duration = "5m"
}

resource "time_sleep" "wait_was" {
  depends_on = [aws_instance.wafo_bastion]

  create_duration = "14m"
}