resource "aws_wafv2_web_acl" "waf" {
  name  = "<env>"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name = "waf-header"
    priority = 0

    action {
      allow {}
    }

    visibility_config {
      metric_name = "waf-header"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled = true
    }

    statement {
      and_statement {
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "<Text>"
              }
            }
            positional_constraint = "CONTAINS"
            search_string = "<Text>"
            text_transformation {
              type     = "NONE"
              priority = 0
            }
          }
        }

        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "<Text>"
              }
            }
            positional_constraint = "CONTAINS"
            search_string = "latest"
            text_transformation {
              type     = "NONE"
              priority = 0
            }
          }
        }
        statement {
          byte_match_statement {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "CONTAINS"
            search_string = "<Path>"
            text_transformation {
              type     = "NONE"
              priority = 0
            }
          }
        }
      }
    }
  }

  visibility_config {
    metric_name                = "<env>"
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
  }
}
