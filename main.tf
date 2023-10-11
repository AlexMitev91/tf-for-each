terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws"{
    region = "us-east-2"
}

locals {
  subnets = {
    "us-east-2a" = "10.10.1.0/24"
    "us-east-2b" = "10.10.2.0/24"
    "us-east-2c" = "10.10.3.0/24"
  }
}

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "private-subnet" {
  for_each = local.subnets

  cidr_block        = each.value
  vpc_id            = aws_vpc.test-vpc.id
  availability_zone = each.key

  tags = {
    Name = "private-subnet-1${substr(each.key, -1, 1)}"
  }
}
