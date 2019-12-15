output "website" {
  value = aws_lb.loadbalancer.dns_name
  description = "DNS name of loadbalancer"
}