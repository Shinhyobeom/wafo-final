# CloudWatch Log groups >>> Lambda >>> S3
resource "aws_iam_role" "role_log_cw_s3" {
  name = "${var.name}-lambda-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
#정책
resource "aws_iam_role_policy" "policy_log_cw_s3" { 
  name = "${var.name}-lambda-policy"
  role = aws_iam_role.role_log_cw_s3.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ses:*",
                "s3:*",
                "lambda:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
# Creating Lambda resource
resource "aws_lambda_function" "wafo_lambda" {
  function_name    = "${var.name}-lambda"
  role             = aws_iam_role.role_log_cw_s3.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = "900"
  filename         = "./lambda_function.zip"
  source_code_hash = filebase64sha256("./lambda_function.zip")
  environment {
    variables = {
      env            = "dev"
      SENDER_EMAIL   = var.lambda_email
      RECEIVER_EMAIL = var.lambda_email
    }
  }
}

# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.wafo_log_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.wafo_lambda.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]

  }
}
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.wafo_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.wafo_log_bucket.id}"
}
