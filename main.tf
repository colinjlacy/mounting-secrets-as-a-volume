locals {
  oidc_string = replace(data.aws_eks_cluster.selected.identity[0].oidc[0].issuer, "https://", "")
}

module "iam_test_service_role" {
  source = "./service-role"
  service_account_name = "iam-test"
  target_namespace = "default"
  oidc_string = local.oidc_string
  aws_account_id = data.aws_caller_identity.account.id
}

