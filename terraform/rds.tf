resource "aws_security_group" "DB-terraform" {
    name        = "DB-terraform"
    description = "DB"

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups     = ["sg-0565b753038dcd334"]
    }

    egress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups     = ["sg-0565b753038dcd334"]
    }

    tags = {
        Name = "DB-terraform"
    }
}

resource "aws_db_instance" "service" {

  identifier             = "testdbtf"
  allocated_storage      = "10"
  availability_zone      = "us-east-1"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "testDB"
  username               = "pxl"
  password               = "pxl"
  vpc_security_group_ids    = ["${aws_security_group.DB-terraform.id}"]
  db_subnet_group_name        = "default-vpc-ef8ae395"
}
