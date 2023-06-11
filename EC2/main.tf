resource "aws_instance" "create_inst" {
  instance_type = "t2.micro"
  ami           = "ami-0b08bfc6ff7069aff"
  #key_name      = "${count.index == 0 ? "peering" : "acceptor"}"
  subnet_id     = var.subnet_id
  security_groups = var.security_groups


  tags  = {
    
    Name  = var.Name
    Owner = "b8g2"
    Purpose = "training"
    
  }

  volume_tags = {
     Name  = var.Name
     Owner = "b8g2"
     Purpose = "training"
  }

}