terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.50" }
    # kubernetes provider not used in this sandbox flow; left here if you re-enable later
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.31" }
  }
}
