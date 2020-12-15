output "vpcid" {
  value = "${module.myvpc.vpcid}"
}

output "public-subnets-ids" {
  value = "${module.myvpc.public_subnet_id}"
}

output "private-subnets-ids" {
  value = "${module.myvpc.private_subnet_id}"
}