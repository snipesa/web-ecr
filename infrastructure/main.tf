resource "aws_ecr_repository" "repo1" {
  name                 = "app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "proxy-vpc"
  }
}

resource "aws_subnet" "sub1_priv" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.cidr_priv1
  availability_zone = var.az_1

  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "sub2_priv" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.cidr_priv2
  availability_zone = var.az_2

  tags = {
    Name = "private2"
  }
}

resource "aws_subnet" "sub3_priv" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.cidr_priv3
  availability_zone = var.az_3

  tags = {
    Name = "private3"
  }
}

resource "aws_subnet" "sub1_pub" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_pub1
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "sub2_pub" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_pub2
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "public2"
  }
}

resource "aws_subnet" "sub3_pub" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.cidr_pub3
  availability_zone       = var.az_3
  map_public_ip_on_launch = true

  tags = {
    Name = "public3"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "mypublic-rt"
  }
}

resource "aws_route_table_association" "public1-rt" {
  subnet_id      = aws_subnet.sub1_pub.id
  route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "public2-rt" {
  subnet_id      = aws_subnet.sub2_pub.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "public3-rt" {
  subnet_id      = aws_subnet.sub3_pub.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_eip" "lb" {
  vpc = true
  tags = {
    Name = "my-eip"
  }
}
resource "aws_nat_gateway" "demo_nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.sub1_pub.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "demo-nat" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo_nat.id
  }
}
resource "aws_route_table_association" "private1-rt" {
  subnet_id      = aws_subnet.sub1_priv.id
  route_table_id = aws_route_table.demo-nat.id
}
resource "aws_route_table_association" "private2-rt" {
  subnet_id      = aws_subnet.sub2_priv.id
  route_table_id = aws_route_table.demo-nat.id
}

resource "aws_route_table_association" "private3-rt" {
  subnet_id      = aws_subnet.sub3_priv.id
  route_table_id = aws_route_table.demo-nat.id
}

resource "aws_security_group" "sg_1" {
  name        = var.sg-web
  description = "Allow tcp and ssh"
  vpc_id      = aws_vpc.myvpc.id

  #allow http
  ingress {
    description = "port 80 vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "port 22 vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}