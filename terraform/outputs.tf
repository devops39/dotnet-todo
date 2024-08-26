output "lambda_function_name" {
  value = aws_lambda_function.todo_app.function_name
}

output "api_url" {
  value = "${aws_api_gateway_deployment.todo_deployment.invoke_url}/todo"
}

