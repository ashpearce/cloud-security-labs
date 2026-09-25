# 04: IAM least privilege

## What this proves
Access is granted through a narrowly scoped role, only to approved identities that present an external ID, and every allowed and denied action is on record.

## What I built
- Policy linting with IAM Access Analyzer, including a deliberately bad policy
- A read-only auditor role in Terraform
  - Trust limited to SSO roles in the account, plus a required external ID
  - Permissions limited to reading S3 security settings and CloudTrail status
  - One-hour maximum session
- A CLI profile that assumes the role automatically

The same pattern works across accounts by changing the account number in the trust policy.

## Control mapping
| Control | How it's met |
|---|---|
| AC-2 Account Management | Role-based access instead of long-lived users |
| AC-6 Least Privilege | Only the specific read actions needed are allowed |
| IA-2 Identification and Authentication | Only SSO-authenticated identities can assume the role |
| CM-4 Impact Analysis | Policies validated before deployment |

## Evidence
| File | Shows |
|---|---|
| `evidence/01-validate-bad-policy.json` | Typo, wildcard, and PassRole problems caught |
| `evidence/02-validate-good-policy.json` | Least-privilege policy passes cleanly |
| `evidence/03-terraform-plan.txt` | Role and policy as planned |
| `evidence/04-whoami-auditor.json` | Session running as the auditor role |
| `evidence/05-allowed-list-buckets.json` | Permitted read action |
| `evidence/06` to `08` | Denied write, denied unrelated service, denied without external ID |