resource "aws_wafv2_web_acl" "waf" {
  name  = "<env>"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  visibility_config {
    metric_name                = "<env>"
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
  }
}
