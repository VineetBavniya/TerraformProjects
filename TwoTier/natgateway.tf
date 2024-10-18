resource "aws_eip" "eip" {
  count  = length(var.tags_for_Elastic_IP)
  domain = "vpc"
  tags = {
    Name = var.tags_for_Elastic_IP[count.index]
  }
}

// # create nat gateway in public subnets

resource "aws_nat_gateway" "nat_gateway_for_public_subnets" {
  for_each      = { for key, index in var.public_subnets : key => index }
  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = each.value.cidr
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${each.value.subnet_Name}_natgateway"
  }
}


// create private route table Pri-RT-A and add route through NAT-GW-A

resource "aws_route_table" "route_table_for_add_nat_gatways" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.tags_for_NAT_Gatways)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_for_public_subnets[count.index].id
  }

  tags = {
    Name = var.tags_for_NAT_Gatways[count.index]
  }
}


//  associate private subnet_ec2_host with route_table_for_add_nat_gatway

resource "aws_route_table_association" "aws_route_table_association_with_private_subnets" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.route_table_for_add_nat_gatways[count.index >= 2 ? 0 : 1].id
}