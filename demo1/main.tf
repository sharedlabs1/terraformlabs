locals {
  ami  = "ami-0a38c1c38a15fed74"
  type = "t2.micro"
  tags = {
    Name = "myfirstvm"
    Env  = "Dev"
  }
  subnet = "subnet-0227dd4741bf489c4"
  nic    = aws_network_interface.mynic.id
}


resource "aws_instance" "myvm1" {
  ami           = local.ami
  instance_type = local.type
  tags          = local.tags
  
  network_interface {

    network_interface_id = local.nic
    device_index         = 0
  }

}

resource "aws_network_interface" "mynic" {
  subnet_id = local.subnet
  description = "My NIC"
  tags = {
    Name = "my nic"
  }
}

