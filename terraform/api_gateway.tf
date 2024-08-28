# Define the API Gateway REST API
resource "aws_api_gateway_rest_api" "todo_api" {
  name        = "Todo API"
  description = "API Gateway for the Todo application"
}

# Create the /todoitems resource
resource "aws_api_gateway_resource" "todoitems" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "todoitems"
}

# Create the POST method for /todoitems
resource "aws_api_gateway_method" "post_todoitems" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todoitems.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integrate the POST method with the Lambda function
resource "aws_api_gateway_integration" "post_todoitems_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todoitems.id
  http_method             = aws_api_gateway_method.post_todoitems.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_app.invoke_arn
}

# Create the GET method for /todoitems
resource "aws_api_gateway_method" "get_todoitems" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todoitems.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate the GET method with the Lambda function
resource "aws_api_gateway_integration" "get_todoitems_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todoitems.id
  http_method             = aws_api_gateway_method.get_todoitems.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_app.invoke_arn
}

# Deploy the API to the "prod" stage
resource "aws_api_gateway_deployment" "todo_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_todoitems_integration,
    aws_api_gateway_integration.get_todoitems_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  stage_name  = "prod"
}
