
# tf-eks-starter

Minimal Terraform setup for an EKS cluster with baseline network policies.

## Features

* VPC with public/private subnets
* NAT Gateway + Internet Gateway
* VPC Gateway Endpoints for S3 and DynamoDB
* EKS cluster with managed node group
* Default-deny NetworkPolicy + DNS allowlist (applied via `kubectl`)
* Basic rollback/canary runbook

Why This Matters

This project provides a clean, reproducible foundation for running Kubernetes on AWS with sensible defaults. You get an isolated VPC, a minimal yet secure egress setup, and a locked-down cluster that can actually be used in demos, labs, or as a springboard for production. From here, you can experiment with Cilium for advanced eBPF networking, add Ingress controllers and service meshes, or expand into monitoring/observability stacks. It’s meant to save you from boilerplate and let you focus on the parts that matter for your specific use case.


## Requirements

* Terraform ≥ 1.5
* AWS CLI with credentials configured
* `kubectl` installed

## Usage

```bash
terraform init
terraform apply -auto-approve

aws eks update-kubeconfig --name tf-eks-starter-eks --region us-west-2
kubectl get nodes
kubectl get netpol -A
```

## Repo Layout

* `*.tf` — Terraform configs
* `k8s/` — NetworkPolicy manifests
* `RUNBOOK.md` — rollback + canary notes
* `Makefile` — helper commands (`make apply`, `make netpols`)
* `.gitignore`, `LICENSE`

## Next Steps

* Swap VPC CNI → Cilium for advanced egress control
* Add ALB Ingress + demo app for canary rollout
* Expand runbook with full rollback procedures

