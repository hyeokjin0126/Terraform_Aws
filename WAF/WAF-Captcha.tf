resource "aws_wafv2_web_acl" "waf" {
  name  = "<env>"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name = "captcha-all"
    priority = 0

    action {
      captcha {}
    }

    visibility_config {
      metric_name = "captcha-all"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled = true
    }

    statement {
      byte_match_statement {
        search_string = "/"
        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }

        positional_constraint = "CONTAINS"
      }
    }
  }

  visibility_config {
    metric_name                = "<env>"
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
  }
}
