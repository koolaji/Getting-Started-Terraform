resource "aws_lb" "nginx" {
    name = "globo_web_alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.public_subnet1.id,aws_route_table_association.app_subnet2.id]
    enable_deletion_protection = true
    tags = local.common_tags
}


resource "aws_lb_target_group" "nginx" {
    name = "globo_web_alb_tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.app.id
    tags = local.common_tags
}

resource "aws_lb_listener" "nginx" { 
    load_balancer_arn = aws_lb.nginx.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.nginx.arn
    }
    tags = local.common_tags
}

resource "aws_lb_target_group_attachment" "nginx1" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx1.id
  port             = 80 
}

resource "aws_lb_target_group_attachment" "nginx2" {
    target_group_arn = aws_instance.nginx2
    target_id        = aws_instance.nginx2.id
    port             = 80
  
}
