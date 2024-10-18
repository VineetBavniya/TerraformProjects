// first create a hostzone inside aws and use 
data "aws_route53_zone" "public_zone" {
  name         = "kyaptakya.work.gd"
  private_zone = false
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name = "" // put your domain name here 
  type = "A"

  alias {
    name = "" // cloudfront domain name 
    zone_id = "" // cloudfront hosted zone id 
    evaluate_target_health = false
  }
}