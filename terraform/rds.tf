resource "aws_security_group" "database" {
  name        = "DB-terraform"
  description = "DB"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web.id}"]
  }

  tags = {
    Name = "DB-terraform"
  }
}

data "aws_db_snapshot" "testDBsnapshot" {
    most_recent = true
    db_instance_identifier = "testdbtf"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.privA.id}", "${aws_subnet.privB.id}", "${aws_subnet.privC.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "service" {
  allocated_storage           = "10"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.16"
  instance_class              = "db.t2.micro"
  name                        = "testDB"
  username                    = "pxl"
  password                    = "pxlpxlpxl"
  identifier                  = "testdbtf"
# skip_final_snapshot         = true
  snapshot_identifier         = "${data.aws_db_snapshot.testDBsnapshot.id}"
  db_subnet_group_name        = aws_db_subnet_group.default.name
  multi_az                    = true
  allow_major_version_upgrade = true
}
