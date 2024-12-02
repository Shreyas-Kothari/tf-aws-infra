resource "aws_lambda_function" "shreyas_tf_sns_email_processor" {
  function_name = "Email_Processor"
  role          = aws_iam_role.shreyas_tf_lambda_role.arn
  handler       = "org.shreyas.EmailHandler::handleRequest"
  runtime       = "java17"
  timeout       = 60
  memory_size   = 128

  filename    = var.serverless_file_path
  kms_key_arn = aws_kms_key.shreyas_tf_sm_kms_key.arn
  environment {
    variables = {
      REGION              = var.aws_region
      SECRET_MANAGER_NAME = aws_secretsmanager_secret.shreyas_tf_secret.name
    }
  }

  tags = {
    Name = "CSYE6225 SNS Email Processor Lambda Function"
  }
}