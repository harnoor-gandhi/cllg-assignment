resource "aws_security_group" "create_sg" {


    name  =   var.name
    description = "alowing only ssh to connect with ec2 and then connect to another ec2 which is in private vpc"
    vpc_id      = var.vpc_id


    ingress {


      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = var.cidr_blocks


    }


    egress  {


      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks  = ["0.0.0.0/0"]


    }

    
    tags  = {


      Name  = var.Name


    }
}

output "id" {
  value = aws_security_group.create_sg.id
}