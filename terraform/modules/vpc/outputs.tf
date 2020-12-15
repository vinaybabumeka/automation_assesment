output "vpcid" {
    value = aws_vpc.k8s_vpc.id
}

output "public_subnet_id" {
    value = aws_subnet.public_subnets[*].id
}

output "private_subnet_id" {
    value = aws_subnet.private_subnets[*].id
}