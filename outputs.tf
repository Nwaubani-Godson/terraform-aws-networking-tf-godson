locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.main_subnet[key].id
      availability_zone = aws_subnet.main_subnet[key].availability_zone
    }
  }
  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.main_subnet[key].id
      availability_zone = aws_subnet.main_subnet[key].availability_zone
    }
  }

}

output "vpc_id" {
  description = "The ID of the VPC created."
  value       = aws_vpc.main_vpc.id
}

output "public_subnets" {
  description = "List of private subnets created in the VPC."
  value       = local.output_public_subnets
}

output "private_subnets" {
  description = "List of public subnets created in the VPC."
  value       = local.output_private_subnets
}