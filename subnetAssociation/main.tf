// associating requester_route_table with public_subnet


resource "aws_route_table_association" "requester_rt_association" {
    
     subnet_id       = var.subnet_id
     route_table_id  = var.route_table_id


}