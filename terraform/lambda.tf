resource "aws_iam_role" "lambda_role" {
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
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "todo_app" {
  function_name = "todo-app-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.8"  # Change to your application runtime
  filename      = "path/to/your/package.zip"  # Path to your packaged Lambda deployment file

  vpc_config {
    subnet_ids         = data.aws_subnet_ids.default.ids
    security_group_ids = [data.aws_security_group.default.id]
  }

  environment {
    variables = {
      # Add any environment variables your Lambda function requires
    }
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

data "aws_vpc" "default" {
  default = true
}
