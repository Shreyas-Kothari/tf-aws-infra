data "aws_caller_identity" "current" {}

resource "aws_kms_key" "shreyas_tf_db_kms_key" {
  description             = "KMS key for encrypting the database password"
  enable_key_rotation     = true
  rotation_period_in_days = var.kms_retention_days
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "db_kms_key_policy",
    Statement = [
      {
        Sid    = "Enable root IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/awscli"
        },
        Action   = "kms:*",
        Resource = "arn:aws:rds:${var.aws_region}:${data.aws_caller_identity.current.account_id}:db:*"
      }
    ]
  })
  tags = {
    Name = "CSYE6225 Cloud Database KMS Key"
  }
}

resource "aws_kms_alias" "shreyas_tf_db_kms_key" {
  name          = "alias/shreyas_tf_db_kms_key-${random_id.suffix.hex}"
  target_key_id = aws_kms_key.shreyas_tf_db_kms_key.id
}

resource "aws_kms_key" "shreyas_tf_s3_kms_key" {
  description             = "KMS key for encrypting the S3 bucket"
  enable_key_rotation     = true
  rotation_period_in_days = var.kms_retention_days
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "s3_kms_key_policy",
    Statement = [
      {
        Sid    = "Enable root IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/awscli"
        },
        Action   = "kms:*",
        Resource = "arn:aws:s3:::*"
      }
    ]
  })
  tags = {
    Name = "CSYE6225 Cloud S3 Storage KMS Key"
  }
}

resource "aws_kms_alias" "shreyas_tf_s3_kms_key" {
  name          = "alias/shreyas_tf_s3_kms_key-${random_id.suffix.hex}"
  target_key_id = aws_kms_key.shreyas_tf_s3_kms_key.id
}

resource "aws_kms_key" "shreyas_tf_ec2_kms_key" {
  description             = "KMS key for encrypting the EC2 instances"
  enable_key_rotation     = true
  rotation_period_in_days = var.kms_retention_days
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "ec2_kms_key_policy",
    Statement = [
      {
        Sid    = "Enable root IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        Sid    = "Enable EC2 to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.ec2_s3_cw_sns_access_role.name}"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow Secrets Manager to Use KMS Key",
        Effect = "Allow",
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        },
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "CSYE6225 Cloud EC2 KMS Key"
  }
}

resource "aws_kms_alias" "shreyas_tf_ec2_kms_key" {
  name          = "alias/shreyas_tf_ec2_kms_key-${random_id.suffix.hex}"
  target_key_id = aws_kms_key.shreyas_tf_ec2_kms_key.id
}

resource "aws_kms_key" "shreyas_tf_sm_kms_key" {
  description             = "KMS key for encrypting the Secrets Manager"
  enable_key_rotation     = true
  rotation_period_in_days = var.kms_retention_days
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "sm_kms_key_policy",
    Statement = [
      {
        Sid    = "Enable root IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/awscli"
        },
        Action   = "kms:*",
        Resource = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:*"
      },
      {
        Sid = "Allow Lambda to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.shreyas_tf_lambda_role.arn
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Sid = "Allow EC2 to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.ec2_s3_cw_sns_access_role.arn
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"  
      }
    ]
  })

  tags = {
    Name = "CSYE6225 Cloud Secrets Manager KMS Key"
  }
}

resource "aws_kms_alias" "shreyas_tf_sm_kms_key" {
  name          = "alias/shreyas_tf_sm_kms_key-${random_id.suffix.hex}"
  target_key_id = aws_kms_key.shreyas_tf_sm_kms_key.id
}