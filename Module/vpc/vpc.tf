resource "aws_vpc" "VPC" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = var.vpc_tag
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.VPC.id
    tags = {
        Name = var.igw_name
    }
}


resource "aws_subnet" "nginx-1" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.subnet_az[0]
    map_public_ip_on_launch = var.map_public_ip_on_launch[0]
    tags = {
        Name = var.subnet_name[0]
    }
}

resource "aws_subnet" "nginx-2" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.subnet_az[1]
    map_public_ip_on_launch = var.map_public_ip_on_launch[0]
    tags = {
        Name = var.subnet_name[1]
    }
}

resource "aws_subnet" "tomcat-1" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = var.subnet_cidr_block[2]
    availability_zone = var.subnet_az[0]
    map_public_ip_on_launch = var.map_public_ip_on_launch[1]
    tags = {
        Name = var.subnet_name[2]
    }
}

resource "aws_subnet" "tomcat-2" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = var.subnet_cidr_block[3]
    availability_zone = var.subnet_az[1]
    map_public_ip_on_launch = var.map_public_ip_on_launch[1]
    tags = {
        Name = var.subnet_name[3]
    }
}

resource "aws_eip" "nat-1" {
  domain = "vpc" 
}

resource "aws_nat_gateway" "NAT-1" {
    subnet_id = aws_subnet.nginx-1.id
    allocation_id = aws_eip.nat-1.id
    tags = {
        Name = "NAT Gateway-1"
    }
}

resource "aws_eip" "nat-2" {
  domain = "vpc" 
}

resource "aws_nat_gateway" "NAT-2" {
    subnet_id = aws_subnet.nginx-2.id
    allocation_id = aws_eip.nat-2.id
    tags = {
        Name = "NAT Gateway-2"
    }
}

resource "aws_route_table" "RT-1" {
    vpc_id = aws_vpc.VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rt-association-1" {
    subnet_id = aws_subnet.nginx-1.id
    route_table_id = aws_route_table.RT-1.id 
}

resource "aws_route_table_association" "rt-association-2" {
    subnet_id = aws_subnet.nginx-2.id
    route_table_id = aws_route_table.RT-1.id 
}

resource "aws_route_table" "RT-2" {
    vpc_id = aws_vpc.VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NAT-1.id
    }
}

resource "aws_route_table_association" "association-2" {
    subnet_id = aws_subnet.tomcat-1.id
    route_table_id = aws_route_table.RT-2.id
}



resource "aws_route_table" "RT-3" {
    vpc_id = aws_vpc.VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NAT-2.id
    }
}

resource "aws_route_table_association" "association-3" {
    subnet_id = aws_subnet.tomcat-2.id 
    route_table_id = aws_route_table.RT-3.id
}

resource "aws_security_group" "SG" {
    name = var.sg_name
    description = "Allow port ssh, http, mariadb, tomcat"
    vpc_id = aws_vpc.VPC.id

    ingress {
        from_port   = var.ports[0]
        to_port     = var.ports[0]
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = var.ports[1]
        to_port     = var.ports[1]
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.ports[2]
        to_port = var.ports[2]
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.ports[3]
        to_port = var.ports[3]
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = var.ports[4]
        to_port = var.ports[4]
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}