output "data_aws_AZ" {
  value = data.aws_availability_zones.available.names
}

output "data_vpcs_ids" {
  value = data.aws_vpcs.default.ids
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
