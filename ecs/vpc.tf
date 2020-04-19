provider "aws" {
  region            = var.region
}


resource "aws_vpc" "nm" {
  cidr_block        = var.vpc_cidr_block

  tags = {
    Name = "NM"
  }
}


resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.nm.id
  availability_zone = join("",[var.region,var.subnet.public.a.az_postfix])
  cidr_block        = var.subnet.public.a.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public_a"
  }
}
  

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.nm.id
  availability_zone = join("",[var.region,var.subnet.public.b.az_postfix])
  cidr_block        = var.subnet.public.b.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public_b"
  }
}


resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.nm.id
  availability_zone = join("",[var.region,var.subnet.private.a.az_postfix])
  cidr_block        = var.subnet.private.a.cidr_block
  map_public_ip_on_launch = false

  tags = {
    Name = "private_a"
  }
}


resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.nm.id
  availability_zone = join("",[var.region,var.subnet.private.b.az_postfix])
  cidr_block        = var.subnet.private.b.cidr_block
  map_public_ip_on_launch = false

  tags = {
    Name = "private_b"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id            = aws_vpc.nm.id

  tags = {
    Name = "NM"
  }
}


resource "aws_route_table" "public" {
  vpc_id            = aws_vpc.nm.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}
  

resource "aws_route_table_association" "public_a" {
  subnet_id         = aws_subnet.public_a.id
  route_table_id    = aws_route_table.public.id
}


resource "aws_route_table_association" "public_b" {
  subnet_id         = aws_subnet.public_b.id
  route_table_id    = aws_route_table.public.id
}


resource "aws_instance" "nat" {
  ami               = data.aws_ami.nat_amzn.image_id
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.nat.id]
  source_dest_check = false
  associate_public_ip_address = true

  tags = {
    Name = "NAT"
  }
}


resource "aws_eip" "nat" {
  instance          = aws_instance.nat.id
  vpc               = true
}


resource "aws_route" "nat" {
  route_table_id            = aws_vpc.nm.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  instance_id               = aws_instance.nat.id
}
