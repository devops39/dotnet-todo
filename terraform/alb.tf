# Reference the existing S3 bucket
data "aws_s3_bucket" "alb_logs" {
  bucket = "myappbucket99"  # Reference the existing bucket name
}

# Public Access Block for S3 Bucket
resource "aws_s3_bucket_public_access_block" "alb_logs_public_access" {
  bucket = data.aws_s3_bucket.alb_logs.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}




# S3 Bucket Versioning Configuration
resource "aws_s3_bucket_versioning" "alb_logs_versioning" {
  bucket = data.aws_s3_bucket.alb_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Fetch AWS Account ID
data "aws_caller_identity" "current" {}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnets.default.ids

  access_logs {
    bucket  = data.aws_s3_bucket.alb_logs.bucket
    prefix  = "alb"
    enabled = true
  }
}

# Target Group for Lambda Function with Health Checks
resource "aws_lb_target_group" "lambda_tg" {
  name        = "lambda-tg"
  target_type = "lambda"
  vpc_id      = data.aws_vpc.default.id

  # Health Check Configuration
  health_check {
    enabled             = true
    path                = "/todoitems"
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
resource "aws_lambda_permission" "alb_lambda" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todo_app.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda_tg.arn
}
