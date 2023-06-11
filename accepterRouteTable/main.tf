/* creating route_table in accepter_vpc in which our destination is the cidr of public_subnet of requester_vpc and target is the id of peering_connection */


resource "aws_route_table" "accepter_rt" {


    vpc_id  = var.vpc_id


    route {

      cidr_block        = "10.0.0.0/20"
      vpc_peering_connection_id  = var.vpc_peering_connection_id


    }



    tags = {

        Name    = "accepter_routetable"
    }
}

output "id" {
  value = aws_route_table.accepter_rt.id
}










