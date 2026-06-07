#VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.project_name}-vpc"
    }
}
#Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}

#Public Subnet AZ-a
resource "aws_subnet" "public_1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project_name}-public-subnet-1a"
    }
}

# Public Subnet AZ-c
resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1c"
  }
}

#ルートテーブル
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.project_name}-public-rtb"
    }
  
}

# Public ルートテーブルとサブネットの関連付け
resource "aws_route_table_association" "public-1a" {
    subnet_id = aws_subnet.public_1a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1c" {
    subnet_id = aws_subnet.public_1c.id
    route_table_id = aws_route_table.public.id
}

#Elastic IP(NAT Gateway用)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags= {
    Name = "${var.project_name}-nat-eip"
  }
}

#NAT Gateway (Public Subnet AZ-aに配置)
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public_1a.id

    tags = {
        Name = "${var.project_name}-natgw"
    }

    depends_on = [ aws_internet_gateway.main ]
}

#プライベートサブネット
resource "aws_subnet" "private_1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "ap-northeast-1a"
    tags = {
        Name = "${var.project_name}-private-subnet-1a"
    }
}

resource "aws_subnet" "private_1c" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.11.0/24"
    availability_zone = "ap-northeast-1c"
    tags = {
        Name = "${var.project_name}-private-subnet-1c"
    }
  
}

#ルートテーブル作成（プライベートサブネット用）
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }
    tags = {
        Name = "${var.project_name}-private-rtb"
    }
  
}

#privateルートテーブルをサブネットに割り当て
resource "aws_route_table_association" "private-1a" {
    subnet_id = aws_subnet.private_1a.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1c" {
    subnet_id = aws_subnet.private_1c.id
    route_table_id = aws_route_table.private.id
}

#Security Group(Public用)
resource "aws_security_group" "public" {
    name = "${var.project_name}-public-sg"
    description = "SSH from my IP"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 22
        to_port = 22
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
      Name = "${var.project_name}-public-sg"
    }
}

#Security Group(Private用)
resource "aws_security_group" "private" {
    name = "${var.project_name}-private-sg"
    description = "SSH from public-sg only"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.public.id]
    }

    egress  {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.project_name}-private-sg"
    }
}

