
# resource "aws_vpc" "create_vpc" {
 
#   count      = "${length(var.list)}"
#   cidr_block = "${lookup(var.map, element(var.list, count.index))}"


#   tags = {

#     Name  = var.list[count.index]


#   }
# }


# resource "aws_vpc_peering_connection" "just_peer" {
  
#   vpc_id        = "${aws_vpc.create_vpc[0].id}"
#   peer_vpc_id   = "${aws_vpc.create_vpc[1].id}"
  
#   auto_accept   =  true


#  tags = {

#      Name   =   "just_peer"


#  }  


# }

# resource "aws_subnet" "create_subnet" {
 
#   count = "${length(var.list)}"
#   availability_zone = "${count.index  ==  0 ? "ap-south-1a" : "ap-south-1b"}"
#   vpc_id  = "${element(aws_vpc.create_vpc.*.id, count.index)}"


#   map_public_ip_on_launch = "${count.index == 0 ? "true" : "false"}"
#   cidr_block = "10.${count.index}.0.0/20"
   
#   tags = {

#     Name = "${count.index == 0 ? "public_subnet" : "private_subnet"}"


#   }
# }

# resource "aws_internet_gateway" "requester_igw" {

#   vpc_id = aws_vpc.create_vpc[0].id


#   tags = {

#     Name = "requester_igw"


#   }
# }

# resource "aws_route_table" "accepter_rt" {


#     vpc_id  = "${module.creating_VPC[1].id}"


#     route {

#       cidr_block        = "10.0.0.0/20"
#       vpc_peering_connection_id     = "${aws_vpc_peering_connection.just_peer.id}"


#     }

#     depends_on  = [aws_vpc_peering_connection.just_peer]


#     tags = {

#         Name    = "accepter_routetable"
#         vpc_peering_connection_id = "${aws_vpc_peering_connection.just_peer.id}"
#     }
# }

# resource "aws_route_table" "requester_rt" {


#     vpc_id  = "${aws_vpc.create_vpc[0].id}"


#     route {

#       cidr_block        = "0.0.0.0/0"
#       gateway_id        = "${aws_internet_gateway.requester_igw.id}"


#     }


#     route {

#       cidr_block        = "10.1.0.0/20"
#       vpc_peering_connection_id     = "${aws_vpc_peering_connection.just_peer.id}"


#     }

#     depends_on  = [aws_vpc_peering_connection.just_peer]


#     tags = {

#         Name    = "requester_routetable"
#     }
# }

# resource "aws_route_table_association" "requester_rt_association" {
    
#      subnet_id       = "${aws_subnet.create_subnet[0].id}"
#      route_table_id  = "${aws_route_table.requester_rt.id }"


# }

# resource "aws_route_table_association" "accepter_rt_association" {
    
#     subnet_id       = "${aws_subnet.create_subnet[1].id}"
#     route_table_id  = "${aws_route_table.accepter_rt.id }"


# }


# resource "aws_security_group" "create_sg" {


#     count =   2
#     name  =   "${count.index  == 0 ? "requester_sg" : "accepter_sg"}"
#     description = "alowing only ssh to connect with ec2 and then connect to another ec2 which is in private vpc"
#     vpc_id      = "${module.creating_VPC[count.index].vpc_id}"


#     ingress {


#       from_port = 22
#       to_port   = 22
#       protocol  = "tcp"
#       cidr_blocks = [count.index  ==  0 ? "0.0.0.0/0" : "10.${count.index -1}.0.0/20"]


#     }


#     egress  {


#       from_port = 0
#       to_port   = 0
#       protocol  = "-1"
#       cidr_blocks  = ["0.0.0.0/0"]


#     }


#     tags  = {


#       Name  = "${count.index  == 0 ? "requester_sg" : "accepter_sg"}"


#     }
# }

// launching both the instances with different key_pair


# resource "aws_instance" "create_inst" {
#   count = 2
#   instance_type = "t2.micro"
#   ami           = "ami-0b08bfc6ff7069aff"
#   #key_name      = "${count.index == 0 ? "peering" : "acceptor"}"
#   subnet_id     = "${module.creating_Subnets[count.index].id}"
#   security_groups = [aws_security_group.create_sg[count.index].id ]


#   tags  = {
    
#     Name  = "${count.index  == 0 ? "public_inst" : "private_inst"}"
    
#   }

#   volume_tags = {
#      Name  = "${count.index  == 0 ? "public_inst" : "private_inst"}"
#   }

#   depends_on = [ module.creating_Subnets ]
# }

// created two vpc with name requester and accepter vpc

module "creating_VPC" {
  source = "./vpc"
  count      = "${length(var.list)}"
  cidr_block = "${lookup(var.map, element(var.list, count.index))}"
  Name = var.list[count.index]
    
}

// created vpc peering connection between both vpc by auto-accepting the request

module "EshtablishingPeering" {
    source = "./vpc peering"
   vpc_id        = "${module.creating_VPC[0].vpc_id}"
   peer_vpc_id   = "${module.creating_VPC[1].vpc_id}"
   depends_on =   [module.creating_VPC]

  
}

// creating public subnet in requester_vpc and private subnet in accepter_vpc

module "creating_Subnets" {
    source = "./subnets and IG"
  count = "${length(var.list)}"
  az = "${count.index  ==  0 ? "ap-south-1a" : "ap-south-1b"}"
  vpc_id  = "${element(module.creating_VPC.*.vpc_id, count.index)}"


  isPublic = "${count.index == 0 ? "true" : "false"}"
  cidr_block = "10.${count.index}.0.0/20"

  Name = "${count.index == 0 ? "public_subnet" : "private_subnet"}"
   
}

// attaching internet gateway to the public subnet which is in requester_vpc

module "attachingIG" {
  source = "./IG"
  vpc_id = module.creating_VPC[0].vpc_id
}

/* creating route_table in accepter_vpc in which our destination is the cidr of public_subnet of requester_vpc and target is the id of peering_connection */

module "creating_RT_requester" {
  source = "./requesterRouteTable"
  vpc_id  = "${module.creating_VPC[0].vpc_id}"
  vpc_peering_connection_id = "${module.EshtablishingPeering.id}"
  gateway_id   = "${module.attachingIG.id}"


  depends_on  = [module.EshtablishingPeering.id]
}

/* creating route_table in requester_vpc in which our destination is the cidr of private_subnet of accepter_vpc and target is the id of peering_connection */

module "creating_RT_accepter" {
  source = "./accepterRouteTable"
  vpc_id  = "${module.creating_VPC[1].vpc_id}"
  vpc_peering_connection_id = "${module.EshtablishingPeering.id}"

  depends_on  = [module.EshtablishingPeering.id]

}

// associating requester_route_table with public_subnet

module "publicSubnetAssociation" {
  source = "./subnetAssociation"
  subnet_id       = "${module.creating_Subnets[0].id}"
  route_table_id  = "${module.creating_RT_requester.id}"
}

//associating accepter_route_table with private_subnet

module "privateSubnetAssociation" {
  source = "./subnetAssociation2"
  subnet_id       = "${module.creating_Subnets[1].id}"
  route_table_id  = "${module.creating_RT_accepter.id }"
}

// creating security_group for both the instances i.e. public and private 

module "create_sg" {
  count = 2
  source = "./SG"
  name  =   "${count.index  == 0 ? "requester_sg" : "accepter_sg"}"
  vpc_id      = "${module.creating_VPC[count.index].vpc_id}"
  cidr_blocks = [count.index  ==  0 ? "0.0.0.0/0" : "10.${count.index -1}.0.0/20"]
  Name  = "${count.index  == 0 ? "requester_sg" : "accepter_sg"}"

}

//creating the ec2 instances
module "create_ec2" {
  count = 2
  source = "./EC2"
  subnet_id     = "${module.creating_Subnets[count.index].id}"
  security_groups = [module.create_sg[count.index].id ]
  Name  = "${count.index  == 0 ? "public_inst" : "private_inst"}"
  depends_on = [ module.creating_Subnets ]
}