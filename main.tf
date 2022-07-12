provider "aws" {
    region = "${var.region}"
  }

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}

# generating a random string so that each clone is unique
resource "random_string" "random" {
  length           = 12
  special          = false
  lower            = true
  upper            = false
}

# getting the latest snapshot of our production DB

data "aws_db_instance" "database" {
  db_instance_identifier = "${var.original_instance_name}"
}

data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = data.aws_db_instance.database.id
}

# create RDS instance from snapshot
resource "aws_db_instance" "primary" {
    identifier = "dbsnap${random_string.random.result}"
    snapshot_identifier = "${data.aws_db_snapshot.db_snapshot.id}"
    instance_class = "db.t3.micro"
    vpc_security_group_ids = [var.db_sg_id]
    skip_final_snapshot = true
    final_snapshot_identifier = "snapshot-${random_string.random.result}"
    parameter_group_name = "default.mysql8.0"
    publicly_accessible = true
    timeouts {
      create = "2h"
    }
}

# output the connection information (since we will want to connect to it)
output "snapshot_endpoint" {
    value = aws_db_instance.primary.endpoint
}