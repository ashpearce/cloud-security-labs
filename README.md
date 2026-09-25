# Cloud Security Engineering Labs

Hands-on labs I built to practice cloud security engineering end to end: writing controls as code, proving they work, and capturing evidence an assessor could use.

Every commit in this repo is signed, and every lab has an `evidence/` folder with the raw output that shows the control working.

| Lab | What it proves | NIST 800-53 |
|---|---|---|
| [01 Kubernetes policy](01-kubernetes-policy/) | Admission control and continuous audit with OPA Gatekeeper | AC-6, CM-2, CA-7 |
| [02 AWS detection](02-detection-aws/) | Config drift detection, GuardDuty, and CloudTrail alarms | AU-6, CA-7, SI-4, CM-3 |
| [03 Vulnerability scanning](03-vuln-scanning/) | Image and IaC scanning, SBOMs, and a CI gate that blocks critical CVEs | RA-5, SI-2, SA-11, CM-8 |
| [04 IAM least privilege](04-iam-least-privilege/) | Scoped role assumption with an external ID and policy validation | AC-2, AC-6, IA-2 |
| [05 Linux hardening](05-linux-hardening/) | STIG scan, scripted remediation, and rescan on Ubuntu 22.04 | CM-6, CM-7, AU-2 |
| [06 Azure network security](06-azure-network-security/) | Segmented VNet, NSG rules, and storage locked to TLS 1.2 | SC-7, SC-8, AC-4 |

## Tooling

Terraform, Rego and OPA Gatekeeper, kind, Trivy, GitHub Actions, AWS CLI, Azure CLI, OpenSCAP.

## About the evidence

AWS account IDs and email addresses are replaced with placeholders before anything is committed. Cloud resources are destroyed after each lab; the code rebuilds them.

Built by Ashley Pearce.