output "cluster_name"         { value = module.eks.cluster_name }
output "region"               { value = var.region }
output "vpc_id"               { value = module.vpc.vpc_id }
output "private_subnets"      { value = module.vpc.private_subnets }
output "s3_endpoint_id"       { value = aws_vpc_endpoint.s3.id }
output "dynamo_endpoint_id"   { value = aws_vpc_endpoint.dynamodb.id }
