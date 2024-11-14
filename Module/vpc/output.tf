output "nginx_subnet_ids" {
  value = [aws_subnet.nginx-1.id, aws_subnet.nginx-2.id]
}

output "tomcat_subnet_ids" {
  value = [aws_subnet.tomcat-1.id, aws_subnet.tomcat-2.id]
}

output "sg_id" {
    value = aws_security_group.SG.id
}