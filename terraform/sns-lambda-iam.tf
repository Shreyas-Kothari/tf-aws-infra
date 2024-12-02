resource "aws_iam_role" "shreyas_tf_lambda_role" {
  name = "CSYE6225LambdaSNSRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policy for Lambda to read from SNS
resource "aws_iam_policy" "lambda_sns_policy" {
  name        = "LambdaSNSPolicy"
  description = "Policy for Lambda to access SNS and SES"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:Publish",
          "sns:Subscribe",
          "sns:Receive"
        ],
        Resource = [
          "${aws_sns_topic.shreyas_tf_sns_topic.arn}"
        ]
      }
    ]
  })
}

# Policy for Lambda to write logs to CloudWatch
resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "LambdaCloudwatchPolicy"
  description = "Policy for Lambda to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Policy for Lambda to decrypt KMS key
resource "aws_iam_policy" "lambda_kms_policy" {
  name        = "LambdaKMSPolicy"
  description = "Policy for Lambda to decrypt KMS key"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ],
        Resource = [
          "${aws_kms_key.shreyas_tf_sm_kms_key.arn}"
        ]
      }
    ]
  })
}

# IAM Policy for Lambda to access Secrets Manager
resource "aws_iam_policy" "lambda_secrets_manager_policy" {
  name        = "LambdaSecretsManagerPolicy"
  description = "Policy for Lambda to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:ListSecrets"
        ],
        Resource = [
          "${aws_secretsmanager_secret.shreyas_tf_secret.arn}"
        ]
      }
    ]
  })
}

# Attach the policy to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_lambda_cloudwatch" {
  role       = aws_iam_role.shreyas_tf_lambda_role.name
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
}

# Attach the policy to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_lambda_sns_policy" {
  role       = aws_iam_role.shreyas_tf_lambda_role.name
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
}

# Attach the secret manager policy to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_lambda_secrets_manager_policy" {
  role       = aws_iam_role.shreyas_tf_lambda_role.name
  policy_arn = aws_iam_policy.lambda_secrets_manager_policy.arn
}

# Attach the KMS policy to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_lambda_kms_policy" {
  role       = aws_iam_role.shreyas_tf_lambda_role.name
  policy_arn = aws_iam_policy.lambda_kms_policy.arn
}

# Allow SNS to invoke Lambda i.e subscribe Lambda to SNS
resource "aws_lambda_permission" "shreyas_tf_allow_sns_trigger" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shreyas_tf_sns_email_processor.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.shreyas_tf_sns_topic.arn
}

# IAM policy for EC2 role to access SNS
resource "aws_iam_policy" "ec2_sns_publish_policy" {
  name        = "EC2SNSPublishPolicy"
  description = "Policy to allow EC2 to publish to SNS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sns:Publish",
        Resource = "${aws_sns_topic.shreyas_tf_sns_topic.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_sns_publish_attachment" {
  role       = aws_iam_role.ec2_s3_cw_sns_access_role.name
  policy_arn = aws_iam_policy.ec2_sns_publish_policy.arn
}