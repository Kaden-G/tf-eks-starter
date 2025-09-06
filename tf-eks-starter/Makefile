SHELL := /bin/bash -eo pipefail
REGION ?= us-west-2
CLUSTER ?= tf-eks-starter-eks

init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve

kubeconfig:
	aws eks update-kubeconfig --name $(CLUSTER) --region $(REGION)

netpols: kubeconfig
	kubectl apply -f k8s/00-default-deny.yaml
	kubectl apply -f k8s/01-allow-kube-dns.yaml
	kubectl get netpol -A

clean:
	rm -rf .terraform *.tfstate* .terraform.lock.hcl
