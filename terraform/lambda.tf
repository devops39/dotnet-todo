resource "aws_iam_role" "terraadmin" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.terraadmin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Add a policy to allow managing network interfaces
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.terraadmin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "todo_app" {
  function_name = "todo-app-lambda"
  role          = aws_iam_role.terraadmin.arn
  handler       = "TodoApp::TodoApp.Function::FunctionHandler"      # Update with the correct handler for your function
  runtime       = "dotnet 8.0"               # Update with the correct runtime for your function
  s3_bucket     = "myappbucket99"     # Replace with your S3 bucket name
  s3_key        = "dotnet-todo.zip"  # Replace with the S3 key (path) to your ZIP file

  vpc_config {
    subnet_ids         = data.aws_subnets.default.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      # Add any environment variables your Lambda function requires
    }
  }
}

