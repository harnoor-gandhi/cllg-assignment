
// attaching internet gateway to the public subnet which is in requester_vpc


resource "aws_internet_gateway" "requester_igw" {

  vpc_id = var.vpc_id


  tags = {

    Name = "requester_igw"


  }
}

output "id" {
  value = aws_internet_gateway.requester_igw.id
}