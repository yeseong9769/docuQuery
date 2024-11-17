########## VPC ##########
resource "aws_vpc" "docuQuery_vpc" {
  cidr_block           = "172.28.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "docuQuery-vpc"
  }
}

########## Public Subnet ##########
resource "aws_subnet" "docuQuery_subnet_public1" {
  vpc_id            = aws_vpc.docuQuery_vpc.id
  cidr_block        = "172.28.0.0/20"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "docuQuery-subnet-public1-ap-northeast-2a"
  }
}

resource "aws_subnet" "docuQuery_subnet_public2" {
  vpc_id            = aws_vpc.docuQuery_vpc.id
  cidr_block        = "172.28.16.0/20"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "docuQuery-subnet-public2-ap-northeast-2c"
  }
}

########## Private Subnet ##########
resource "aws_subnet" "docuQuery_subnet_private1" {
  vpc_id            = aws_vpc.docuQuery_vpc.id
  cidr_block        = "172.28.128.0/22"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "docuQuery-subnet-private1-ap-northeast-2a"
  }
}

resource "aws_subnet" "docuQuery_subnet_private2" {
  vpc_id            = aws_vpc.docuQuery_vpc.id
  cidr_block        = "172.28.132.0/22"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "docuQuery-subnet-private2-ap-northeast-2c"
  }
}

resource "aws_subnet" "docuQuery_subnet_private3" {
  vpc_id            = aws_vpc.docuQuery_vpc.id
  cidr_block        = "172.28.136.0/22"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "docuQuery-subnet-private3-ap-northeast-2a"
  }
}

resource "aws_subnet" "docuQuery_subnet_private4" {
  vpc_id            = aws_vpc.docuQuery_vpc.id
  cidr_block        = "172.28.140.0/22"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "docuQuery-subnet-private4-ap-northeast-2c"
  }
}