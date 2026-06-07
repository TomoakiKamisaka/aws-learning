output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

# Note: other outputs were removed because corresponding resources
# (subnets, NAT EIP) are not declared in this module.
