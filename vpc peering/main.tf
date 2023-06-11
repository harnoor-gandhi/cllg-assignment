resource "aws_vpc_peering_connection" "just_peer" {
  
  vpc_id        = var.vpc_id
  peer_vpc_id   = var.peer_vpc_id
  
  auto_accept   =  true


 tags = {

     Name   =   "just_peer"
}  


}

output "id" {
  value = aws_vpc_peering_connection.just_peer.id
}

