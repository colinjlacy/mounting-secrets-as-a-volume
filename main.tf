locals {
  oidc_string = replace(data.aws_eks_cluster.selected.identity[0].oidc[0].issuer, "https://", "")
  aws_account_id = data.aws_caller_identity.account.id
}

module "iam_test_service_role" {
  source = "modules/service-role"
  service_account_name = "iam-test"
  target_namespace = "default"
  oidc_string = local.oidc_string
  aws_account_id = local.aws_account_id
}

module "another_test_service_role" {
  source = "modules/service-role"
  service_account_name = "another-test"
  target_namespace = "something-else"
  oidc_string = local.oidc_string
  aws_account_id = local.aws_account_id
}

