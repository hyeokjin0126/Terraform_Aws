resource "aws_wafv2_web_acl" "waf" {
  name  = "<env>"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name = "deny-country"
    priority = 0

    action {
      block {}
    }

    visibility_config {
      metric_name = "deny-country"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled = true
    }
    
    statement {
      geo_match_statement {
        country_codes = ["<Country_Code>"]
        }
      }
    }

  visibility_config {
    metric_name                = "<env>"
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
  }
}

# ISO 3166-1 Country Code - https://ko.wikipedia.org/wiki/%EA%B5%AD%EA%B0%80%EB%B3%84_%EA%B5%AD%EA%B0%80_%EC%BD%94%EB%93%9C_%EB%AA%A9%EB%A1%9D