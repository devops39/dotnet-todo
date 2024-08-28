# Fetch AWS Account ID
data "aws_caller_identity" "current" {}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnets.default.ids
}

# Target Group for Lambda Function with Health Checks
resource "aws_lb_target_group" "lambda_tg" {
  name        = "lambda-tg"
  target_type = "lambda"
  vpc_id      = data.aws_vpc.default.id

  # Health Check Configuration
  health_check {
    enabled             = true
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# HTTP Listener for ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda_tg.arn
  }
}

# Listener Rule for Specific Path
resource "aws_lb_listener_rule" "route_todoitems" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda_tg.arn
  }

  condition {
    path_pattern {
      values = ["/todoitems*"]
    }
  }
}

# Lambda Permission for ALB to Invoke the Function
#resource "aws_lambda_permission" "alb_lambda" {
 # statement_id  = "AllowExecutionFromALB"
 # function_name = aws_lambda_function.todo_app.function_name  # Ensure this is the correct function name
 # principal     = "elasticloadbalancing.amazonaws.com"
  #source_arn    = aws_lb_target_group.lambda_tg.arn

  # Ensure that the Lambda function is created before applying this permission
  #depends_on = [aws_lambda_function.todo_app]
#}
