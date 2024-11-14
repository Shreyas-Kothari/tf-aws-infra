resource "aws_lambda_function" "shreyas_tf_sns_email_processor" {
  function_name = "Email_Processor"
  role          = aws_iam_role.shreyas_tf_lambda_role.arn
  handler       = "org.shreyas.EmailHandler::handleRequest"
  runtime       = "java17"
  timeout       = 60
  memory_size   = 128

  filename = var.serverless_file_path

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