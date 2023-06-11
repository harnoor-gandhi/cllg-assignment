/* creating route_table in requester_vpc in which our destination is the cidr of private_subnet of accepter_vpc and target is the id of peering_connection */


resource "aws_route_table" "requester_rt" {


    vpc_id  = var.vpc_id


    route {

      cidr_block        = "0.0.0.0/0"
      gateway_id        = var.gateway_id


    }


    route {

      cidr_block        = "10.1.0.0/20"
      vpc_peering_connection_id  = var.vpc_peering_connection_id


    }


    tags = {

        Name    = "requester_routetable"
    }
}

output "id" {
  value = aws_route_table.requester_rt.id
}

