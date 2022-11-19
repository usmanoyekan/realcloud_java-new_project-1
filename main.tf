provider "aws" {
  region     = "us-east-2"
  profile = "default"
  
}

# Create an EC2 Instance
#resource "aws_instance" "firstinstance" {
 # ami           = "ami-0d5bf08bc8017c83b"
  #instance_type = "t2.micro"

  #tags = {
   # Name = "Web-Server"
  #}
#}

# Create a VPC

resource "aws_vpc" "prodvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "production_vpc"
  }
}


# Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prodvpc.id

  tags = {
    Name = "ProdIGW"
  }
}

# Create a Subnet
resource "aws_subnet" "prodsubnet1" {
  vpc_id     = aws_vpc.prodvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "prodSubnet"
  }
}
# Create a Route Table
resource "aws_route_table" "prodroute" {
  vpc_id = aws_vpc.prodvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  

  tags = {
    Name = "RT"
  }
}

# Associate subnet with Route Table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prodsubnet1.id
  route_table_id = aws_route_table.prodroute.id
}

# Create security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow WEB inbound traffic"
  vpc_id      = aws_vpc.prodvpc.id

  ingress {
    description      = "Webtraffic from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "Webtraffic from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "Webtraffic from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # Any ip address/ any protocol
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls"
  }
}



# Use data source to get register ubuntu linux
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



# Create a Instance and security group

resource "aws_instance" "firstinstance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.prodsubnet1.id
  vpc_security_group_ids    = [aws_security_group.allow_web.id]
  key_name   = "new_key_pair-ohio"
  availability_zone = "us-east-2a"
  user_data = "${file("install_jenkins.sh")}"

  tags = {
    Name = "Jenkins-Server"
  }
}

output "website_ip" {
  description = "Public IP address of the EC2 instance"
  value       = join ("", ["http://", aws_instance.firstinstance.public_ip, ":", "8080"])
}
