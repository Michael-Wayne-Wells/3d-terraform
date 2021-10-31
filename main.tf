terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}
resource "aws_vpc" "main" {
  cidr_block      = var.main_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
}
resource "aws_subnet" "publicA" {
  depends_on = [
    aws_vpc.main
  ]
  cidr_block = "172.16.1.0/24" 
  vpc_id = aws_vpc.main.id
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicA"
  }
}

resource "aws_instance" "helloworld" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
