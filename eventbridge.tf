#### Trigger Lambda Weekly ####
# resource "aws_cloudwatch_event_rule" "weekly_rds_maintenance_check" {
#   name                = "weekly-rds-maintenance-check"
#   description         = "Triggers Lambda every Saturday to check for pending RDS maintenance"
#   schedule_expression = "cron(0 12 ? * 7 *)" # Runs every Saturday at 12:00 PM UTC
#   # schedule_expression = "rate(1 minute)"
# }

# resource "aws_cloudwatch_event_target" "lambda_target" {
#   rule = aws_cloudwatch_event_rule.weekly_rds_maintenance_check.name
#   arn  = aws_lambda_function.my_lambda.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromEventBridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.my_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.weekly_rds_maintenance_check.arn
# }

#### Whenever RDS maintenance is available trigger lambda ####
resource "aws_cloudwatch_event_rule" "rds_maintenance_rule" {
  name        = "rds-maintenance-rule"
  description = "Trigger Lambda function for RDS maintenance events"
  event_pattern = jsonencode({
    source = ["aws.rds"],
    detail_type = ["RDS DB Instance Event"],
    detail = {
      eventCategories = ["maintenance"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.rds_maintenance_rule.name
  arn  = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rds_maintenance_rule.arn
}

