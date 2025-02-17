# VPC 네트워크

## vpc create
```
resource "aws_vpc" "skills-vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        Name = "skills-vpc"
    }
}
```

## public subnet create
```
resource "aws_subnet" "skills-pub-sub-a" {
  vpc_id                  = aws_vpc.skills-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "skills-pub-sub-a"
  }
}

resource "aws_subnet" "skills-pub-sub-b" {
  vpc_id                  = aws_vpc.skills-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2b"

  tags = {
    Name = "skills-pub-sub-b"
  }
}
```

## public subnet conect
```
resource "aws_internet_gateway" "skills-igw" {
  vpc_id = aws_vpc.skills-vpc.id
  tags   = { Name = "skills-igw" }
}

resource "aws_route_table" "skills-public-rt" {
  vpc_id                  = aws_vpc.skills-vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.skills-igw.id
  }
  tags   = { Name = "skills-pub-rt" }
}

resource "aws_route_table_association" "public-a-join" {
  subnet_id      = aws_subnet.skills-pub-sub-a.id
  route_table_id = aws_route_table.skills-public-rt.id
}
resource "aws_route_table_association" "public-b-join" {
  subnet_id      = aws_subnet.skills-pub-sub-b.id
  route_table_id = aws_route_table.skills-public-rt.id
}
```

## private subnet create
```
resource "aws_subnet" "skills-private-a" {
  vpc_id                  = aws_vpc.skills-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "skills-private-a"
  }
}

resource "aws_subnet" "skills-private-b" {
  vpc_id                  = aws_vpc.skills-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-northeast-2b"

  tags = {
    Name = "skills-private-b"
  }
}
```

## private subnet conect
```
resource "aws_eip" "skills-nat-a-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "skills-nat-a" {
  allocation_id = aws_eip.skills-nat-a-eip.id
  subnet_id     = aws_subnet.skills-public-a.id
  tags = { Name = "skills-nat-a" }
}

resource "aws_eip" "skills-nat-b-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "skills-nat-b" {
  allocation_id = aws_eip.skills-nat-b-eip.id
  subnet_id     = aws_subnet.skills-public-b.id
  tags = { Name = "skills-nat-b" }
}


resource "aws_route_table" "skills-priv-a-rt" {
  vpc_id                  = aws_vpc.vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.skills-nat-a.id
  }
  tags   = { Name = "skills-priv-a-rt" }
}

resource "aws_route_table" "skills-priv-b-rt" {
  vpc_id                  = aws_vpc.vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.skills-nat-b.id
  }
  tags   = { Name = "skills-priv-b-rt" }
}


resource "aws_route_table_association" "skills-priv-a-conect" {
  subnet_id      = aws_subnet.skills-private-a.id
  route_table_id = aws_route_table.skills-priv-a-rt.id
}
resource "aws_route_table_association" "skills-priv-b-conect" {
  subnet_id      = aws_subnet.skills-private-b.id
  route_table_id = aws_route_table.skills-priv-b-rt.id
}
```
