resource "aws_kms_key" "kms" {
    key_usage = "ENCRYPT_DECRYPT" # ENCRYPT_DECRYPT or SIGN_VERIFY or GENERATE_VERIFY_MAC
    deletion_window_in_days = 7 # Default 30 Days
    # customer_master_key_spec = "SYMMETRIC_DEFAULT" # SYMMETRIC_DEFAULT or RSA_2048 or RSA_307 or RSA_4096 or HMAC_256 or ECC_NIST_P256 or ECC_NIST_P384 or ECC_NIST_P521 or ECC_SECG_P256K1
    # multi_region = ture # Default False

  tags = {
    Name = "<env>-kms"
  }
}

resource "aws_kms_alias" "kms" {
    target_key_id = aws_kms_key.kms.key_id
    name = "alias/<env>-kms"
}

output "kms_id" {
    value = aws_kms_key.kms.key_id
}

output "kms_alias" {
    value = aws_kms_alias.kms.arn
}