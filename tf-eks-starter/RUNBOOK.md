# EKS Demo – Rollback & Canary Runbook

## Scope
Small EKS cluster for demos (VPC + endpoints + default-deny). This runbook covers: rollback of TF changes and a canary app deploy/rollback.

## Rollback (Terraform)
1) Identify failed apply: `terraform plan` shows drift/errors.
2) Quick revert to last good: `git checkout <last_good_commit>` then `terraform apply -auto-approve`.
3) If node group broken:
   - Scale to zero: edit eks_managed_node_groups desired_size=0, `apply`.
   - Restore desired_size=1 and `apply`.
4) If kube provider failing mid-apply:
   - `-target=module.eks` first, then re-run full apply.

## Canary Deploy (example skeleton)
1) Deploy v1 stable: `kubectl -n default apply -f deploy-v1.yaml`.
2) Add v2 canary at 10%: `kubectl apply -f svc-split-90-10.yaml` (or use two ReplicaSets).
3) Watch SLOs: p95 latency, error rate.
4) Rollback:
   - `kubectl rollout undo deployment myapp` (if Deployment)
   - Or revert Service split to 100% v1.
5) Post-incident:
   - Capture `kubectl describe`, logs, and note dashboard screenshots in /docs.

## Egress hardening (next iteration)
- Swap Amazon VPC CNI to Cilium; add L3/L7 egress policies to VPC endpoint prefixes only.
- Remove NAT (if feasible); keep gateway endpoints; tighten SGs/NACLs.
