tf-eks-starter
==============

Minimal, reproducible Terraform for a VPC, gateway endpoints (S3/DynamoDB), and an EKS cluster with a default-deny + DNS-allow NetworkPolicy applied via kubectl.

Prereqs
- Terraform ≥ 1.5
- AWS CLI configured for an account
- kubectl
- (Optional) direnv/Make

Quick start
```bash
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --name tf-eks-starter-eks --region us-west-2
kubectl get nodes -o wide
kubectl get netpol -A
```

Repo layout
- `*.tf` – core Terraform for VPC, endpoints, and EKS
- `k8s/` – baseline NetworkPolicies
- `RUNBOOK.md` – tiny rollback/canary notes
- `.gitignore` – Terraform and local cruft

Next steps
- Swap VPC CNI -> Cilium for L3/L7 egress control
- Replace NAT with tighter egress via VPC endpoints
- Add ALB Ingress + demo app with 90/10 canary split
