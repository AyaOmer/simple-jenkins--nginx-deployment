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
 user_data = <<-EOF
                #!/bin/bash
                 sudo apt update -y
                 sudo apt install -y nginx
                 sudo systemctl enable --now nginx
               
                 # Create a sample index.html file
                 sudo tee /var/www/html/index.html > /dev/null << 'HTML'
                 <!DOCTYPE html>
                 <html lang="en">
                <head>
                     <meta charset="UTF-8">
                     <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Terraform Project</title>
                    <style>
                         body {
                             background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
                             font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                             color: #333;
                             padding: 40px;
                             margin: 0;
                             display: flex;
                             justify-content: center;
                             align-items: center;
                             height: 100vh;
                             text-align: center;
                         }

                         .container {
                             background-color: rgba(255, 255, 255, 0.8);
                             padding: 30px;
                             border-radius: 15px;
                             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                             max-width: 600px;
                             width: 100%;
                         }

                         .title {
                             font-size: 26px;
                             font-weight: bold;
                             color: #2c3e50;
                             margin-bottom: 20px;
                         }

                         .created-by, .hostname {
                             font-size: 18px;
                             margin-bottom: 10px;
                         }

                         .created-by {
                             color: #8e44ad;
                         }

                         .hostname {
                             color: #3498db;
                             font-family: "Courier New", Courier, monospace;
                         }

                         footer {
                             margin-top: 20px;
                             font-size: 14px;
                             color: #7f8c8d;
                         }
                     </style>
                 </head>
                 <body>
                     <div class="container">
                         <div class="title">Deploying a Secure Multi-Tier Web Application on AWS with Private Subnets and Public Load Balancer</div>
                         <div class="created-by">Created By: Aya Omar</div>
                         <div class="created-by">public Instance </div>
                         <div class="hostname">The HostName: $(hostname) " </div>
                         <footer>© 2024 Aya Omar. All rights reserved.</footer>
                     </div>
                 </body>
                 </html>
                 HTML
                 EOF
 

  tags = {
    Name = var.ec2_name[count.index]
  }
}










