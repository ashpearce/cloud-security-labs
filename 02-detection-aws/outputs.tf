output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}

output "alerts_topic_arn" {
  value = aws_sns_topic.security_alerts.arn
}

output "log_bucket" {
  value = aws_s3_bucket.logs.id
}