output "store_vpc_id" {
    description = "This is the public IP for the EC2 instance"
    value = aws_vpc.store_vpc.id
}

output "store_igw_id" {
    description = "This is the public IP for the EC2 instance"
    value = aws_internet_gateway.store_igw.id
}

output "store_route_table_id" {
    description = "This is the public IP for the EC2 instance"
    value = aws_route_table.store_route_table.id
}

output "instance_public_ip" {
    description = "This is the public IP for the EC2 instance"
    value = aws_instance.store_frontend.id
}
