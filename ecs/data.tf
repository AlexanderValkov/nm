data "aws_ami" "ecs" {
  most_recent = true
  owners = ["591542846629"] # amazon

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
