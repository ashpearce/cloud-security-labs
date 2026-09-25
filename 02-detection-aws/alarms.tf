# AU-6 / IR-6: turn specific CloudTrail events into alerts
resource "aws_sns_topic" "security_alerts" {
  name = "csl-security-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

locals {
  detections = {
    root-account-usage = {
      pattern     = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
      description = "Root account was used (AC-6(9), AU-6)"
    }
    security-group-changes = {
      pattern     = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
      description = "A security group was created, changed, or deleted (CM-3, SI-4)"
    }
    console-login-without-mfa = {
      pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.userIdentity.type = \"IAMUser\") && ($.responseElements.ConsoleLogin = \"Success\") }"
      description = "An IAM user signed in to the console without MFA (IA-2(1))"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "detections" {
  for_each       = local.detections
  name           = "csl-${each.key}"
  log_group_name = aws_cloudwatch_log_group.trail.name
  pattern        = each.value.pattern

  metric_transformation {
    name      = each.key
    namespace = "CSL/Detections"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "detections" {
  for_each            = local.detections
  alarm_name          = "csl-${each.key}"
  alarm_description   = each.value.description
  namespace           = "CSL/Detections"
  metric_name         = each.key
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]

  depends_on = [aws_cloudwatch_log_metric_filter.detections]
}