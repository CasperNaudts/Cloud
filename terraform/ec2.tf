resource "aws_security_group" "web" {
  name        = "web-terraform"
  description = "web"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.loadbalancer.id}"]
  }

  egress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-terraform"
  }
}

resource "aws_instance" "weba1" {
  ami                    = "ami-08617a11c1209fe48"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "Project"
  subnet_id              = "${aws_subnet.privA.id}"

  tags = {
    Name = "terraform-web-A1"
  }
}

resource "aws_instance" "webb1" {
  ami                    = "ami-08617a11c1209fe48"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "Project"
  subnet_id              = "${aws_subnet.privB.id}"

  tags = {
    Name = "terraform-web-B1"
  }
}
