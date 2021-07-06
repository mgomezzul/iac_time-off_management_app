data "aws_elb_service_account" "default" {
  #count = module.this.enabled ? 1 : 0
}

data "aws_iam_policy_document" "default" {
  # count = module.this.enabled ? 1 : 0
  statement {
    sid = ""
    principals {
      type        = "AWS"
      identifiers = [join("", data.aws_elb_service_account.default.*.arn)]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}