variable "cluster_name" {
    description = "enter the k8s cluster name"
    type = string
}

###VPC Variables
variable "vpc_cidr" {
    type = string
    description = "VPC CIDR"
    default = "10.0.0.0/16"
}

variable "vpc_dns_support" {
    type = bool
    description = "enable/disable DNS support in the VPC"
    default = "true"
}

variable "vpc_dns_hostnames" {
    type = bool
    description = "enable/disable DNS hostnames in the VPC"
    default = "false"
}

variable "vpc_tenancy" {
    type = string
    description = "tenancy shared or dedicated"
    default = "default"
}

###public_subnets
variable "public_subnets" {
    type = map
    description = "A map of public availability zones to CIDR blocks, which will be set up as subnets."
}

variable "private_subnets" {
    type = map
    description = "A map of private availability zones to CIDR blocks, which will be set up as subnets."
}