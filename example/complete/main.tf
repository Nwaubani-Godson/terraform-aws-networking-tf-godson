module "vpc" {
  source = "./modules/networking"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "10-local-modules"
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
    subnet_3 = {
      cidr_block = "10.0.2.0/24"
      az         = "us-east-1c"
    }
    subnet_4 = {
      cidr_block = "10.0.3.0/24"
      # Public subnets are indicated by setting the public option to true.
      public = true
      az     = "us-east-1d"
    }
  }
}
