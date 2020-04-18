resource "aws_launch_configuration" "ecs" {
  name_prefix   = "ecst2"
  image_id      = data.aws_ami.ecs.id
  instance_type = "t2.micro"
  key_name          = var.key_name
#  associate_public_ip_address = true
  security_groups   = [aws_security_group.ecs_service.id]
  enable_monitoring = false
  iam_instance_profile = "ecsInstanceRole"
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=nm >> /etc/ecs/ecs.config
EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "ecs" {
  name                      = "ecs"
  max_size                  = 3
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.ecs.name
  vpc_zone_identifier       = [aws_subnet.private_a.id,aws_subnet.private_b.id]
}


resource "aws_ecs_cluster" "nm" {
  name = "nm"

  tags = {
    Name = "NM"
  }
}


resource "aws_ecs_task_definition" "nm" {
  family                = "nm"
  container_definitions = file("task-definitions/service.json")

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
  target_type = "instance"
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
  launch_type     = "EC2"

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
