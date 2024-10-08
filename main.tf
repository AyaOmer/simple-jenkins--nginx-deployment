provider "aws" {
    region = "us-east-1"
  
}
resource "aws_instance" "apche_ec2" {
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  count=2

  subnet_id              = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.apcheSG.id]
associate_public_ip_address = true
key_name = "ayakey"
provisioner "local-exec" {
    command = "echo The arn is : ${self.arn}"
  
}


  tags = {
    Name = var.ec2_name[count.index]
  }
}










