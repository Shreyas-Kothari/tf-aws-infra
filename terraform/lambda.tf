resource "aws_lambda_function" "shreyas_tf_sns_email_processor" {
  function_name = "Email_Processor"
  role          = aws_iam_role.shreyas_tf_lambda_role.arn
  handler       = "org.shreyas.EmailHandler::handleRequest"
  runtime       = "java17"
  timeout       = 100
  memory_size   = 128

  filename = var.serverless_file_path

  # vpc_config {
  #   subnet_ids = aws_subnet.shreyas_terraform_pub_subnet[*].id
  #   security_group_ids = [aws_security_group.shreyas_terraform_lambda_sg.id]
  # }

  environment {
    variables = {
      MAIL_GUN_API_KEY     = var.mailgun_api_key
      MAIL_GUN_DOMAIN_NAME = var.domain_name
    }
  }

  tags = {
    Name = "CSYE6225 SNS Email Processor Lambda Function"
  }
}