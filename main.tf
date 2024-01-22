resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.sub-cidr-1
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-sub1"
  }

}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.sub-cidr-2
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-sub2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "my-igw"
  }

}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "RTa" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "RTb" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_security_group" "sg" {
  name        = "Security Group"
  description = "Open 22,443,80"
  vpc_id      = aws_vpc.vpc.id

ingress = [
    for port in [22, 80, 443] : {
      description      = "Allow SSH ,HTTP and HTTPD inbound traffic"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
}

