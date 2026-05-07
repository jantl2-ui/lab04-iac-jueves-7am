# ─────────────────────────────────────────────
# CloudWatch Log Groups
# ─────────────────────────────────────────────

resource "aws_cloudwatch_log_group" "upload_lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-upload-lambda"
  retention_in_days = var.retention_in_days

  tags = { Name = "${var.project_name}-${var.environment}-upload-lambda-logs" }
}

resource "aws_cloudwatch_log_group" "crop_lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-crop-lambda"
  retention_in_days = var.retention_in_days

  tags = { Name = "${var.project_name}-${var.environment}-crop-lambda-logs" }
}

resource "aws_cloudwatch_log_group" "apigw_logs" {
  name              = "/aws/apigateway/${var.project_name}-${var.environment}-access-logs"
  retention_in_days = var.retention_in_days

  tags = { Name = "${var.project_name}-${var.environment}-apigw-access-logs" }
}

# ─────────────────────────────────────────────
# SNS Topic para alertas
# ─────────────────────────────────────────────

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = { Name = "${var.project_name}-${var.environment}-alerts" }
}

# ─────────────────────────────────────────────
# CloudWatch Alarms
# ─────────────────────────────────────────────

# Alarma: mensajes en DLQ (procesamiento fallido)
resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-dlq-messages"
  alarm_description   = "Se detectaron mensajes en la DLQ, lo que indica fallos en el procesamiento de imágenes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = var.dlq_queue_name
  }

  tags = { Name = "${var.project_name}-${var.environment}-dlq-alarm" }
}

# Alarma: errores en Upload Lambda
resource "aws_cloudwatch_metric_alarm" "upload_lambda_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-upload-lambda-errors"
  alarm_description   = "La Lambda de Upload está generando errores"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.upload_lambda_function_name
  }

  tags = { Name = "${var.project_name}-${var.environment}-upload-errors-alarm" }
}

# Alarma: errores en Crop Lambda
resource "aws_cloudwatch_metric_alarm" "crop_lambda_errors" {
  alarm_name          = "${var.project_name}-${var.environment}-crop-lambda-errors"
  alarm_description   = "La Lambda de Crop está generando errores"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.crop_lambda_function_name
  }

  tags = { Name = "${var.project_name}-${var.environment}-crop-errors-alarm" }
}
