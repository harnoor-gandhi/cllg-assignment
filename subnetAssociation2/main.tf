//associating accepter_route_table with private_subnet


resource "aws_route_table_association" "accepter_rt_association" {
    
    subnet_id       = var.subnet_id
    route_table_id  = var.route_table_id


}