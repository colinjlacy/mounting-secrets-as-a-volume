resource "kubernetes_manifest" "service_account" {
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

resource "kubernetes_manifest" "spc" {
  manifest = {
    "apiVersion" = "secrets-store.csi.x-k8s.io/v1alpha1" # the API the SSCD installed
    "kind"       = "SecretProviderClass" # our new CRD
    "metadata" = {
      "name"      = "${var.service_account_name}-aws-secret" # we'll need this in a minute
      "namespace" = var.target_namespace
    }
    "spec" = {
      "provider" = "aws" # the AWS provider we installed in the first section
      "parameters" = {
        # the secret we created in the second section
        "objects" = <<EOF
            - objectName: "${aws_secretsmanager_secret.secret.name}"
              objectType: "secretsmanager"
        EOF
      }
    }
  }
}