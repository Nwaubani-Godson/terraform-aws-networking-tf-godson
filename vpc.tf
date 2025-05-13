locals {
  public_subnets = {
    for key, config in var.subnet_config : key => config if config.public
  }
  private_subnets = {
    for key, config in var.subnet_config : key => config if !config.public
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = var.vpc_config.name
  }
}

resource "aws_subnet" "main_subnet" {
  for_each                = var.subnet_config
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name   = each.key
    Access = each.value.public ? "Public" : "Private"
  }

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = <<-EOT
        The AZ "${each.value.az}" provided for the subnet "${each.key}" is invalid.

        The applied AWS region "${data.aws_availability_zones.available.id}" supports the following AZs:
        [${join(", ", data.aws_availability_zones.available.names)}]
      EOT
    }
  }
}

resource "aws_internet_gateway" "main_igw" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public_rtb" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw[0].id
  }
}

resource "aws_route_table_association" "public_rtb_assoc" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.main_subnet[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}