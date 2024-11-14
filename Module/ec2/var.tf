variable "nginx_subnet_ids" {
    type = list(string)
    default = ["aws_subnet.nginx-1.id" , "aws_subnet.nginx-2.id"]
}

variable "tomcat_subnet_ids" {
    type = list(string)  
    default = [ "aws_subnet.tomcat-1.id" , "aws_subnet.tomcat-2.id" ]
}

variable "sg_id" {
    type = string
}

