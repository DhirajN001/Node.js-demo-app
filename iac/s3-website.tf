resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.project_name}-static-${random_id.bucket_id.hex}"
  acl    = "public-read"

  website {
    index_document = var.website_index_document
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "no_block" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.project_name}"
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.website_bucket.id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.website_index_document

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "website_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}