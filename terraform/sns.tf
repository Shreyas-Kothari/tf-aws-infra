resource "aws_sns_topic" "shreyas_tf_sns_topic" {
  name         = "csye6225_email_notification"
  display_name = "Email Notification"
}

resource "aws_sns_topic_subscription" "shreyas_tf_lambda_sns_subscription" {
  topic_arn = aws_sns_topic.shreyas_tf_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.shreyas_tf_sns_email_processor.arn
}