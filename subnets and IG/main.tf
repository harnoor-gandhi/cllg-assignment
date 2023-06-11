// creating public subnet in requester_vpc and private subnet in accepter_vpc


resource "aws_subnet" "create_subnet" {
 
  
  availability_zone = var.az
  vpc_id  = var.vpc_id


  map_public_ip_on_launch = var.isPublic
  cidr_block = var.cidr_block
   
  tags = {

    Name = var.Name

  }
}

output "id" {
  value = aws_subnet.create_subnet.id
}




