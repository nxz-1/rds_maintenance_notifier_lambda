resource "aws_lambda_function" "my_lambda" {
  filename      = "rds_maintainence_notifier.zip"
  function_name = "rds_maintainence_notifier"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  environment {
    variables = {
      SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# RDS policy
resource "aws_iam_policy" "lambda_rds_policy" {
  name        = "LambdaRDSPolicy"
  description = "Policy to allow Lambda function to check RDS maintenance events"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:DescribeEvents",
          "rds:DescribeDBInstances",
          "rds:DescribePendingMaintenanceActions"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}