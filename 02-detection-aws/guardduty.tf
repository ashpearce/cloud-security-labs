# SI-4: managed threat detection across CloudTrail, VPC Flow Logs, and DNS logs
resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}