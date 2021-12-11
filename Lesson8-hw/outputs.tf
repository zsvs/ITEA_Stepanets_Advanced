output "data_aws_AZ" {
  value = data.aws_availability_zones.available.names
}

output "Elastic_IP" {
  value = aws_eip.instance_static_addr.address
}

output "data_vpc_ids" {
  value = data.aws_vpc.default.id
}

output "data_aws_region_id" {
  value = data.aws_region.current.id
}

output "data_aws_ec2_instance_name" {
  value = aws_instance.web_server.tags["Name"]
}

output "data_aws_ec2_instance_id" {
  value = aws_instance.web_server.id
}

output "data_aws_ec2_instance_arn" {
  value = aws_instance.web_server.arn
}

output "data_aws_db_instance_name" {
  value = aws_db_instance.l8-rds.name
}

output "data_aws_db_instance_endpoint" {
  value = aws_db_instance.l8-rds.endpoint
}

output "data_aws_db_instance_arn" {
  value = aws_db_instance.l8-rds.arn
}

output "data_aws_db_instance_engine" {
  value = aws_db_instance.l8-rds.engine
}

output "data_aws_db_instance_engine_version" {
  value = aws_db_instance.l8-rds.engine_version
}
