# 01: Kubernetes admission policy with OPA Gatekeeper

## What this proves
Risky workloads are blocked before they run (preventive), and workloads that were already running are found by continuous audit (detective).

## What I built
- A reproducible local cluster (`kind-config.yaml`)
- Two Gatekeeper ConstraintTemplates written in Rego
  - `K8sNoPrivileged`: denies privileged containers
  - `K8sNoLatestTag`: denies `:latest` and untagged images

## Control mapping
| Control | How it's met |
|---|---|
| AC-6 Least Privilege | Privileged containers are denied at admission |
| CM-2 Baseline Configuration | Images must use a pinned version tag |
| CA-7 Continuous Monitoring | Gatekeeper audit re-evaluates running workloads every 60 seconds |

## Evidence
| File | Shows |
|---|---|
| `evidence/01-denied-privileged.txt` | Privileged pod refused by the admission webhook |
| `evidence/02-allowed-good-pod.txt` | Compliant pod admitted |
| `evidence/03-audit-findings.yaml` | Audit found the pre-existing privileged pod |
| `evidence/04-denied-latest.txt` | Untagged image refused |
| `evidence/05-policy-inventory.txt` | Inventory of enforced policies |

## Reproduce
    kind create cluster --config kind-config.yaml
    kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.22.0/deploy/gatekeeper.yaml
    kubectl apply -f policies/