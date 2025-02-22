data "aws_caller_identity" "current" {
}

resource "aws_kms_key" "cw" {
    key_usage = "ENCRYPT_DECRYPT"
    deletion_window_in_days = 7

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Id" : "key-default-1",
        "Statement" : [
            {
                "Sid" : "Enable IAM User Permissions",
                "Effect" : "Allow",
                "Principal" : {
                    "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                },
                "Action" : "kms:*",
                "Resource" : "*"
            },
            {
                "Sid" : "Allow CloudWatch Logs use of the key",
                "Effect" : "Allow",
                "Principal" : {
                    "Service" : "logs.<region>.amazonaws.com"
                },
                "Action" : [
                    "kms:Encrypt",
                    "kms:Decrypt",
                    "kms:ReEncrypt*",
                    "kms:GenerateDataKey*",
                    "kms:DescribeKey"
                ],
                "Resource" : "*"
            }
        ]
    })

    tags = {
        Name = "cw-kms"
    }
}

resource "aws_kms_alias" "cw" {
    target_key_id = aws_kms_key.cw.key_id
    name = "alias/cw-kms"
}

resource "aws_cloudwatch_log_group" "cw" {
    name = "<name>"
    kms_key_id = aws_kms_key.cw.arn
    
    tags = {
        Name = "<name>"
    }
}

output "cw" {
    value = aws_cloudwatch_log_group.cw.id
}