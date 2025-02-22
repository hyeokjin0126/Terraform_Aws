resource "aws_s3_bucket" "s3" {
    bucket = "<S3>"

    tags = {
        Name = "<S3>"
    } 
}

resource "aws_s3_bucket_policy" "access" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.access.json
}

data "aws_iam_policy_document" "access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["<Account>"]
    }

    actions = [
      "<Policy>"
    ]

    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }
}

output "s3" {
    value = aws_s3_bucket.s3.id
}