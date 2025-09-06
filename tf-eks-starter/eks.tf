module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = "${var.project}-eks"
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2_x86_64"
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      subnet_ids     = module.vpc.private_subnets
    }
  }

  cluster_endpoint_public_access = true
  tags = { Project = var.project }
}

/*
# Disabled in sandbox to avoid provider auth race; we apply via kubectl instead.
resource "kubernetes_manifest" "default_deny" {
  manifest   = yamldecode(file("${path.module}/k8s/00-default-deny.yaml"))
  depends_on = [module.eks]
}

resource "kubernetes_manifest" "allow_kube_dns" {
  manifest   = yamldecode(file("${path.module}/k8s/01-allow-kube-dns.yaml"))
  depends_on = [module.eks]
}
*/

# Apply baseline NetworkPolicies using kubectl after the cluster is up
resource "null_resource" "apply_netpols" {
  triggers = {
    cluster_name     = module.eks.cluster_name
    region           = var.region
    default_deny_sha = filesha256("${path.module}/k8s/00-default-deny.yaml")
    allow_dns_sha    = filesha256("${path.module}/k8s/01-allow-kube-dns.yaml")
  }

  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
set -euo pipefail
export AWS_REGION="${var.region}"
aws eks update-kubeconfig --name "${module.eks.cluster_name}" --region "${var.region}"
kubectl wait --for=condition=Ready nodes --all --timeout=120s
kubectl apply -f "${path.module}/k8s/00-default-deny.yaml"
kubectl apply -f "${path.module}/k8s/01-allow-kube-dns.yaml"
kubectl get netpol -A
EOT
    interpreter = ["/bin/bash", "-lc"]
  }
}
