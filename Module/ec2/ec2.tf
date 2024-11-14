resource "aws_launch_template" "Nginx" {
    name                  = "nginx-launch-template"
    image_id              = "ami-0c9f1f679b7812a2f"
    instance_type          = "t2.micro"
    key_name              = "guru"
    vpc_security_group_ids = [ var.sg_id ]
  
}

resource "aws_launch_template" "Tomcat" {
    name                  = "tomcat-launch-template"
    image_id              = "ami-0c9f1f679b7812a2f"
    instance_type          = "t2.micro"
    key_name              = "guru"
    vpc_security_group_ids = [ var.sg_id ]
  
}

# Autoscaling Group for Nginx (across nginx1 and nginx2 subnets)
resource "aws_autoscaling_group" "nginx_asg" {
  launch_template {
    id      = aws_launch_template.Nginx.id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.nginx_subnet_ids # Replace with Nginx subnet IDs (nginx1 and nginx2)
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "nginx-instance"
    propagate_at_launch = true
  }
}

# Autoscaling Group for Tomcat (across tomcat1 and toncat2 subnets)
resource "aws_autoscaling_group" "tomcat_asg" {
  launch_template {
    id      = aws_launch_template.Tomcat.id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.tomcat_subnet_ids  # Replace with Nginx subnet IDs (nginx1 and nginx2)
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "tomcat-instance"
    propagate_at_launch = true
  }
}

