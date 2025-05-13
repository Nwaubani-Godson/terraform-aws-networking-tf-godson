# terraform-aws-networking-tf-godson
Networking module created for easy network infrastructure provisioning

This module manages the creation of VPCs and Subnets, allowing for the creation of both private and public subnet.

Example usage:
```
source = "./modules/networking"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "your_vpc"
  }
  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "us-east-1a"
    }
    subnet_2 = {
      cidr_block = "10.0.1.0/24"
      public     = true
      az         = "us-east-1b"
    }
  }
```
