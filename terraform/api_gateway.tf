# api_gateway.tf

resource "aws_api_gateway_rest_api" "todo_api" {
  name        = "Todo API"
  description = "API Gateway for the Todo application"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "todo"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_todoitems" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_todoitems_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get_todoitems.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_app.invoke_arn
}

# Additional resource and method for /todoitems/{id}
resource "aws_api_gateway_resource" "todoitem_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_resource.resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_todoitem_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todoitem_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_todoitem_by_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.todoitem_id.id
  http_method             = aws_api_gateway_method.get_todoitem_by_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_app.invoke_arn
}


resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.todo_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.todo_app.invoke_arn
}

resource "aws_api_gateway_deployment" "todo_deployment" {
  depends_on  = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.get_todoitems_integration,
    aws_api_gateway_integration.get_todoitem_by_id_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  stage_name  = "prod"
}



