resource "aws_wafv2_web_acl" "waf" {
  name  = "<env>"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name = "block-ip"
    priority = 0

    action {
      block {}
    }

    visibility_config {
      metric_name = "block-ip"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled = true
    }

    statement {
      rate_based_statement {
        limit = "number"
        aggregate_key_type = "IP"
        }
      }
    }

  visibility_config {
    metric_name                = "<env>"
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
  }
}
