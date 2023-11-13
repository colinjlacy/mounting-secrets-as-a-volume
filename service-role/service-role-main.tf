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

resource "kubernetes_manifest" "spc" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = var.service_account_name
      namespace = var.target_namespace
      annotations = {
        "eks.amazonaws.com/role-arn": aws_iam_role.service_role.arn
      }
    }
  }
}
