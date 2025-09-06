variable "project" {
  type    = string
  default = "tf-eks-starter"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}
