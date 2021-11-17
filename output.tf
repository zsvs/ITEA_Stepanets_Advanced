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
