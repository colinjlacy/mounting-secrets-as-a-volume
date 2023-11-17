# generating the password
resource "random_password" "db_password" {
  length           = 16 # feel free to change this or set a var
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # AWS-safe special chars
}

# creating the Secret were we'll store the password
resource "aws_secretsmanager_secret" "secret" {
  name  = "${var.service_account_name}_iam_secret"
}

# actually storing the password value in the Secret
resource "aws_secretsmanager_secret_version" "secret" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(
    merge(
      tomap({}),
      tomap({ "DB_PASS" = random_password.db_password.result })
    )
  )
}
