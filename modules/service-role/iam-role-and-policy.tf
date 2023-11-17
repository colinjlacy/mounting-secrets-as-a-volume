resource "aws_iam_role" "service_role" {
  name = var.service_account_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.oidc_string}"
        }
        Condition = {
          StringEquals = {
            "${var.oidc_string}:sub" : "system:serviceaccount:${var.target_namespace}:${var.service_account_name}"
            "${var.oidc_string}:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "secret_access_policy" {
  name        = "${var.service_account_name}-access-policy"
  description = "Access policy for the ${var.service_account_name} secret"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
      "Resource" : [aws_secretsmanager_secret.secret.arn]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "secret_policy_attachment" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.secret_access_policy.arn
}
