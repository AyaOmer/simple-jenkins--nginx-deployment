resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
     tags = {
    Name = "main-vpc"
  }
}
resource "aws_route_table" "pub_route_table" {

  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {

    route_table_id = aws_route_table.pub_route_table.id
    subnet_id = aws_subnet.public_subnet.id

  
}
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a" 
     tags = {
    Name = "public-subnet"
  }
  
} 

resource "aws_internet_gateway" "igw" {

    vpc_id = aws_vpc.main.id
    tags = {
    Name = "main-igw"
  }
  
}

resource "aws_security_group" "apcheSG" {

    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 22

        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = 80

        to_port = 80
        protocol = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0

        to_port = 0
        protocol = "-1"

        cidr_blocks = ["0.0.0.0/0"]
    }

     tags = {
    Name = "web-sg"
  }
  
}
