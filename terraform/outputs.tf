output "lambda_function_name" {
  value = aws_lambda_function.todo_app.function_name
}



output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
