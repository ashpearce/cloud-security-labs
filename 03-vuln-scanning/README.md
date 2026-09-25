# 03: Vulnerability scanning and a CI gate

## What this proves
Vulnerabilities are found before deployment, in both images and infrastructure code, and a pipeline gate blocks images with critical CVEs until they're fixed.

## What I built
- Local image scanning and CycloneDX SBOM generation with Trivy
- IaC misconfiguration scanning of my own Terraform (Track 02)
- A GitHub Actions workflow that builds the image and fails on CRITICAL findings
  - `actions/checkout` pinned to a full commit SHA
  - Scanner run from a pinned container image
  - Least-privilege workflow token (`contents: read`)

## Control mapping
| Control | How it's met |
|---|---|
| RA-5 Vulnerability Monitoring | Image, SBOM, and IaC scans |
| SI-2 Flaw Remediation | Failing image fixed and re-verified in CI |
| SA-11 Developer Testing | Security testing runs on every relevant push |
| CM-8 Component Inventory | SBOM records every package in the image |
| SR-3 Supply Chain Controls | Actions and tools pinned to immutable references |

## Evidence
| File | Shows |
|---|---|
| `evidence/01-nginx-image-scan.txt` | HIGH and CRITICAL findings in a public image |
| `evidence/02-nginx-sbom.cdx.json` | CycloneDX SBOM |
| `evidence/03-sbom-rescan.txt` | Vulnerability check run from the SBOM alone |
| `evidence/04-iac-scan-track2.txt` | Misconfigurations found in my own Terraform |
| `evidence/05-ci-blocked-critical.txt` | Pipeline blocking the outdated image |
| `evidence/06-ci-history.txt` | Failed run followed by the passing fix |

See the Actions tab for the full run history.