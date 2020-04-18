resource "aws_ecs_cluster" "nm" {
  name = "nm"

  tags = {
    Name = "NM"
  }
}


resource "aws_ecs_task_definition" "nm" {
  family                = "nm"
  container_definitions = file("task-definitions/service.json")
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = 256
  memory                = 512

  tags = {
    Name = "NM"
  }
}


resource "aws_lb" "nm" {
  name               = "nm"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = [aws_subnet.public_a.id,aws_subnet.public_b.id]

  enable_deletion_protection = false
}


resource "aws_lb_target_group" "nm" {
  name        = "nm"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.nm.id
}


resource "aws_lb_listener" "nm" {
  load_balancer_arn = aws_lb.nm.arn
  port        = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nm.arn
  }
}

resource "aws_ecs_service" "nm" {
  name            = "nm"
  cluster         = aws_ecs_cluster.nm.id
  task_definition = aws_ecs_task_definition.nm.arn
  desired_count   = 6
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.private_a.id,aws_subnet.private_b.id]
    security_groups   = [aws_security_group.ecs_service.id]
    assign_public_ip  = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nm.arn
    container_name   = aws_ecs_task_definition.nm.family
    container_port   = 80
  }
  
  depends_on = [
    aws_lb_target_group.nm,
    aws_lb.nm
  ]
}


output "alb_address" {
  value = aws_lb.nm.dns_name
}
