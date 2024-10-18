// aws_acm_certificate is not completed because i have not a  issue certificate for domain 

data "aws_acm_certificate" "issue" {
  domain = 	"" // put here your domain name 
  statuses = ["ISSUED"]
}

#creating Cloudfront distribution :

resource "aws_cloudfront_distribution" "my_mydistribution" {
  enabled = true
  aliases = [] // put inside domain name 

  origin {
    domain_name = "" // alb domain name 
    origin_id = "" // alb domain name 

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = ""
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = []
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["IN", "US", "CA"]
    }
  }
    viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.issue.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  tags = {
    Name = "CloudFront"
  }
}

