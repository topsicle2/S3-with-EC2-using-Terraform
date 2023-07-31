#Create Security Groups
resource "aws_security_group" "int1-pri-sg" {
  name        = "int1-pri-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.int1-vpc.id

  ingress {
    description = "http from load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups    = [aws_security_group.int1-lb-sg.id] 
  }

 ingress {
    description = "ssh from public-sn"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "int1-pri-sg"
  }
}

resource "aws_security_group" "int1-pub-sg" {
  name        = "int1-pub-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.int1-vpc.id

  ingress {
    description = "ssh from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "int1-pub-sg"
  }
}

resource "aws_security_group" "int1-lb-sg" {
  name        = "int1-lb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.int1-vpc.id

  ingress {
    description = "http from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "int1-lb-sg"
  }
}

