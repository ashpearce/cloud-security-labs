# 02: AWS detective controls

## What this proves
Three independent detection layers, each triggered on purpose and captured as evidence: configuration drift, suspicious API activity, and managed threat detection.

## What I built (Terraform)
- Hardened log bucket: encrypted, versioned, no public access, HTTPS-only
- Multi-region CloudTrail with log file validation, streamed to CloudWatch Logs
- AWS Config recorder with versioning and public-read rules
- CloudWatch metric filters and alarms for root usage, security group changes, and console logins without MFA, alerting through SNS
- GuardDuty detector

## Control mapping
| Control | How it's met |
|---|---|
| AU-2, AU-12 | CloudTrail records API activity in all regions |
| AU-9 | Log bucket is locked down; log file validation detects tampering |
| AU-6, IR-6 | Metric filters and alarms route security events to a person |
| CM-3, CA-7 | Config detects and re-evaluates configuration changes |
| SI-4 | GuardDuty monitors for known threat patterns |

## Evidence
| File | Shows |
|---|---|
| `evidence/01-terraform-plan.txt` | Everything built, before it existed |
| `evidence/02-config-drift-detected.json` | Hand-made bucket flagged NON_COMPLIANT |
| `evidence/03-config-drift-remediated.json` | Same bucket COMPLIANT after the fix |
| `evidence/04-alarm-security-group-change.json` | Real security group change fired the alarm |
| `evidence/05-alarm-root-path-test.json` | Root-usage alert path tested |
| `evidence/06-guardduty-findings.json` | GuardDuty sample findings |

## Reproduce
    terraform init
    terraform apply -var="alert_email=you@example.com"