# IAM Role for Lambda Function
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

# Attach the basic execution role policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.terraadmin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach the VPC access policy
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.terraadmin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Create the Lambda function
resource "aws_lambda_function" "todo_app" {
  function_name = "todo-app-lambda"
  role          = aws_iam_role.terraadmin.arn
  handler       = "TodoApp::TodoApp.Function::FunctionHandler"  # Update with the correct handler for your function
  runtime       = "dotnet6"                                     # Use the correct runtime for your function
  s3_bucket     = "myappbucket99"                               # Replace with your S3 bucket name
  s3_key        = "dotnet-todo.zip"                             # Replace with the S3 key (path) to your ZIP file

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

# Allow ALB to invoke the Lambda function
resource "aws_lambda_permission" "alb_lambda_permission" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todo_app.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda_tg.arn  # Replace with your ALB Target Group ARN
}
