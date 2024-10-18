resource "aws_db_subnet_group" "db_subnets" {
  name = "db-subnets-group"
  subnet_ids = [aws_subnet.private_subnets[2].id , aws_subnet.private_subnets[3].id ] 
  // i created four subnet in row like list [0, 1, 2, 3]   
}



resource "aws_db_instance" "db" {
  identifier = var.rds_variables.identifier
  engine = var.rds_variables.engine
  engine_version = var.rds_variables.engine_version
  instance_class = var.rds_variables.instance_class
  allocated_storage = var.rds_variables.allocated_storage
  username = var.rds_variables.username
  password = var.rds_variables.password
  db_name = var.rds_variables.db_name
  multi_az = var.rds_variables.multi_az
  storage_type = var.rds_variables.storage_type
  storage_encrypted = var.rds_variables.storage_encrypted
  publicly_accessible = var.rds_variables.publicly_accessible
  skip_final_snapshot = var.rds_variables.skip_final_snapshot
  backup_retention_period = var.rds_variables.backup_retention_period

  vpc_security_group_ids = [aws_security_group.db_sg.id ]
  db_subnet_group_name = aws_db_subnet_group.db_subnets.id 
  
  tags = {
    Name = var.rds_variables.tagName
  }
}