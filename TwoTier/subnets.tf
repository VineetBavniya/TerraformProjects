resource "aws_subnet" "public_subnets" {
  for_each = { for idx, subName in var.public_subnets : idx => subName }
  vpc_id   = aws_vpc.vpc.id

  availability_zone       = each.value.AZone
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr

  tags = {
    Name = each.value.subnet_Name
  }

}

// private subnets 

resource "aws_subnet" "private_subnets" {
  for_each = { for idx, subName in var.private_subnets : idx => subName }
  vpc_id   = aws_vpc.vpc.id

  availability_zone       = each.value.AZone
  map_public_ip_on_launch = false
  cidr_block              = each.value.cidr

  tags = {
    Name = each.value.subnet_Name
  }

}