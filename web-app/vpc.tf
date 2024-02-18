# Resources to be created:
// Create a VPC
// public route table and routes
// private route table and routes
// public and private subnets
// internet gateway
// NAT gateway
// EIP for NAT gateway

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "terraform_aws_vpc"
  }
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  count                           = var.public_subnet_count
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  tags = {
    Name = "${var.default_tags.project_name}-public-${data.aws_availability_zones.available.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# Create a Public Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.default_tags.project_name}-public-route-table"
  }
}

# Create an Internet Gateway to access the route from internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.default_tags.project_name}-internet-gateway"
  }
}

// Create a Public route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

// Associate Route table with Subnet
resource "aws_route_table_association" "public_rt_subnet_associate" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

// Create a Private Subnet
resource "aws_subnet" "private_subnet" {
  count      = var.private_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.public_subnet_count)
  # ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  # map_public_ip_on_launch = true
  # assign_ipv6_address_on_creation = true
  tags = {
    Name = "${var.default_tags.project_name}-private-${data.aws_availability_zones.available.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# Create a Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.default_tags.project_name}-private-route-table"
  }
}

# Create an EIP for NAT Gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
  tags = {
    Name = "${var.default_tags.project_name}-nat-eip"
  }
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnet.0.id

  tags = {
    Name = "${var.default_tags.project_name}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.nat_gateway, aws_internet_gateway.igw]
}

// Create a Private route
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

// Associate Private Route table with Subnet
resource "aws_route_table_association" "private_rt_subnet_associate" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
