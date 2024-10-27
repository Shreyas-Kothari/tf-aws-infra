#IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "ec2_s3_access_role"

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
  name        = "s3_access_policy"
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

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Attach the IAM role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "ec2_s3_access_instance_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}