resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_secretsmanager_secret" "shreyas_tf_secret" {
  name                    = "shreyas_tf_csye6225_secrets-${random_id.suffix.hex}"
  description             = "Secret for the Terraform Cloud course csye6225"
  kms_key_id              = aws_kms_key.shreyas_tf_sm_kms_key.arn
  recovery_window_in_days = 0
  #   policy = data.aws_iam_policy_document.shreyas_tf_secret_policy.json

  tags = {
    Name = "CSYE6225 Seceret Manager to save the secrets"
  }
}

resource "aws_secretsmanager_secret_version" "shreyas_tf_secret_version" {
  secret_id = aws_secretsmanager_secret.shreyas_tf_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.shreyas_terraform_db_password.result
    api_key  = var.mailgun_api_key
    domain   = var.domain_name
  })
}