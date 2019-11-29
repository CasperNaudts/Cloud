resource "aws_security_group" "database" {
    name        = "DB-terraform"
    description = "DB"

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups     = ["${aws_security_group.web.id}"]
    }

    tags = {
        Name = "DB-terraform"
    }
}

resource "aws_db_instance" "service" {
    allocated_storage      = "10"
    storage_type         = "gp2"
    engine                 = "mysql"
    engine_version         = "5.7"
    instance_class         = "db.t2.micro"
    name                   = "testDB"
    username               = "pxl"
    password               = "pxlpxlpxl"
    parameter_group_name   = "default.mysql5.7"
    identifier             = "testdbtf"
    skip_final_snapshot    = true
    vpc_security_group_ids = ["${aws_security_group.database.id}"]
    availability_zone      = "us-east-1a"
    multi_az               = true
    # db_subnet_group_name   = "${aws_subnet.pubA.id}"
}
