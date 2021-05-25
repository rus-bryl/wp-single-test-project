

data "aws_ami" "latest_ubuntu_linux" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
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

