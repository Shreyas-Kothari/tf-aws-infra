#IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_cw_sns_access_role" {
  name = "EC2S3CloudWatchSNSAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy to allow S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "A policy to allow EC2 instances to access specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.shreyas_tf_s3_bucket.arn}",
          "${aws_s3_bucket.shreyas_tf_s3_bucket.arn}/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket.shreyas_tf_s3_bucket]
}

# IAM Policy to allow Secrets Manager access

resource "aws_iam_policy" "secretsmanager_access_policy" {
  name        = "SecretsManagerAccessPolicy"
  description = "A policy to allow EC2 instances to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:ListSecrets",
          "secretsmanager:BatchGetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.shreyas_tf_secret.arn
      }
    ]
  })
}

resource "aws_iam_policy" "kmsS3_access_policy" {
  name        = "KMSS3AccessPolicy"
  description = "A policy to allow EC2 instances to access KMS key and S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
        ],
        Resource = [
          aws_kms_key.shreyas_tf_s3_kms_key.arn
        ]
      }
    ]
  })
  
}

# Attach the s3 policy to the ec2 role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_s3_cw_sns_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Attach the AWS managed CloudWatchAgentServerPolicy to allow CloudWatch access
resource "aws_iam_role_policy_attachment" "cloudwatch_access_attachment" {
  role       = aws_iam_role.ec2_s3_cw_sns_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the secrets manager policy to the ec2 role
resource "aws_iam_role_policy_attachment" "secretsmanager_access_attachment" {
  role       = aws_iam_role.ec2_s3_cw_sns_access_role.name
  policy_arn = aws_iam_policy.secretsmanager_access_policy.arn
}

# Attach the KMS policy to the ec2 role
resource "aws_iam_role_policy_attachment" "kmsS3_access_attachment" {
  role       = aws_iam_role.ec2_s3_cw_sns_access_role.name
  policy_arn = aws_iam_policy.kmsS3_access_policy.arn
}

# Attach the IAM role to the EC2 instance profile
resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "ec2_s3_access_instance_profile"
  role = aws_iam_role.ec2_s3_cw_sns_access_role.name
}