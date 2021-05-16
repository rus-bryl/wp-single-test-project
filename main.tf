provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest_ubuntu_linux" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_eip" "wp_static_ip" {
  instance = aws_instance.wp_server.id
}

#=====================SSH Keys===============================
variable "ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.ssh_key)
}
#====================Wordpress Server=========================
resource "aws_instance" "wp_server" {
  ami                    = data.aws_ami.latest_ubuntu_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.wp_server.id]
  key_name               = aws_key_pair.deployer.key_name
  tags = {
    Name  = "WordPress Server"
    Owner = "Ruslan Bryl"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "wp_server" {
  name        = "WebServer Security Group"
  description = "Wordpress SecurityGruop"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Wordpress SecurityGroup"
    Owner = "Ruslan Bryl"
  }
}
#===============Outputs======================
output "wp_server_ip" {
  value = aws_instance.wp_server.public_ip
}

output "wp_server_dns" {
  value = aws_instance.wp_server.public_dns
}
