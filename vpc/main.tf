resource "aws_vpc" "create_vpc" {
 
  cidr_block =   var.cidr_block #"${lookup(var.map, element(var.list, count.index))}"


  tags = {

    Name  = var.Name
    
  }
}

output "vpc_id" {
  value = aws_vpc.create_vpc.id
}
