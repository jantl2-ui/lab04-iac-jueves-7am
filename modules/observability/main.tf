resource "aws_cloudwatch_log_group" "upload_lambda_logs" {
  name              = "/aws/lambda/upload-lambda-${var.environment}" 
  retention_in_days = 14 
}

resource "aws_cloudwatch_log_group" "crop_lambda_logs" {
  name              = "/aws/lambda/crop-lambda-${var.environment}" 
  retention_in_days = 14 
}

resource "aws_cloudwatch_log_group" "apigw_logs" {
  name              = "/aws/apigateway/${var.project_name}-${var.environment}-access-logs" 
  retention_in_days = 14 
}

resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name          = "dlq-messages-alarm-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"   
  namespace           = "AWS/SQS"                              
  period              = 60                                      
  statistic           = "Sum"
  threshold           = 0                                       
  alarm_actions       = [var.sns_topic_arn]                     
  dimensions = {
    QueueName = var.dlq_queue_name
  }
}

