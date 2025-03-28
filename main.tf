provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "Sakshipaws" {
      cidr_block = "10.0.0.0/16"
      tags = {
        Name = "project-vpc"
      }
}

resource "aws_subnet" "sak-subnet" {
    vpc_id = aws_vpc.Sakshipaws.id
    cidr_block = "10.0.0.0/16"
    availability_zone = "ap-south-1a"

    tags = {
      Name = "sak-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Sakshipaws.id
  
     tags = {
       Name = "sak-igw"
     }
}

resource "aws_route_table" "route-table" {
   vpc_id = aws_vpc.Sakshipaws.id

  route {
    cidr_block = "0.0.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }
    
    tags = {
      Name = "route-table"
    }
}

resource "aws_route_table_association" "route-table-as" {
  subnet_id = aws_subnet.sak-subnet.id
  route_table_id = aws_route_table.route-table.id
}


resource "aws_instance" "practice-server" {
  ami = "ami-05c179eced2eb9b5b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sak-subnet.id
  key_name = ""
  security_groups = ""
  associate_public_ip_address = true


  tags = {
    Name = "practice-server"
  }

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
    delete_on_termination = true
  }
}