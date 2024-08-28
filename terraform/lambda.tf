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

# Attach ECR access policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_ecr_access" {
  role       = aws_iam_role.terraadmin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Create the Lambda function using ECR image
resource "aws_lambda_function" "todo_app" {
  function_name = "todo-app-lambda"
  role          = aws_iam_role.terraadmin.arn
  package_type  = "Image"  # Indicate that this is an image-based Lambda function
  image_uri     = "607968074640.dkr.ecr.us-east-1.amazonaws.com/devoops39:latest"  # Use your correct image URI

  vpc_config {
    subnet_ids         = data.aws_subnets.default.ids
    security_group_ids = [aws_security_group.lb_sg.id]
  }

  environment {
    variables = {
      # Add any environment variables your Lambda function requires
    }
  }
}

# Allow ALB to invoke the Lambda function
resource "aws_lambda_permission" "alb_lambda_permission" {
  statement_id  = "AllowExecutionFromALB-1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.todo_app.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda_tg.arn  # Replace with your ALB Target Group ARN
}
