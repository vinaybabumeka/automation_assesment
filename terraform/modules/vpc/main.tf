locals {
    cluster_tag = map(
            "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )

    cluster_pub_subnet_tag = map(
            "kubernetes.io/cluster/${var.cluster_name}", "shared",
            "kubernetes.io/role/elb", "1"
    )
    cluster_priv_subnet_tag = map(
            "kubernetes.io/cluster/${var.cluster_name}", "shared",
            "kubernetes.io/role/internal-elb", "1"
    )
}

resource "aws_vpc" "k8s_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = var.vpc_tenancy
    enable_dns_support = var.vpc_dns_support
    enable_dns_hostnames = var.vpc_dns_hostnames
    tags = local.cluster_tag
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.k8s_vpc.id
}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = element(values(var.public_subnets), count.index)
    availability_zone = element(keys(var.public_subnets), count.index)
    map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.igw]
    tags = local.cluster_pub_subnet_tag
}

resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = element(values(var.private_subnets), count.index)
    availability_zone = element(keys(var.private_subnets), count.index)
    depends_on = [aws_internet_gateway.igw]
    tags = local.cluster_priv_subnet_tag
}

resource "aws_route_table" "pubrt" {
    vpc_id = aws_vpc.k8s_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_eip" "natip" {
  vpc              = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.natip.id
  subnet_id     = aws_subnet.public_subnets[0].id
}

resource "aws_route_table" "privrt" {
    vpc_id = aws_vpc.k8s_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw.id
    }
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.pubrt.id
}


resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.privrt.id
}
