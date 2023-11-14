# EKS + IAM + OpenTofu

This repo serves as a demo to accompany [this blog post](https://colinj.hashnode.dev/mapping-an-eks-serviceaccount-to-an-aws-iam-role-using-opentofu), which goes through the mapping process for tying an EKS `ServiceAccount` to an IAM Role.  Whereas the first two sections of the blog post discuss some alternate ways to do it, and how that mapping is achieved in the AWS inner workings, this shows the recommended approach, which leverages OpenTofu to create the `ServiceAccount` and IAM Role in a repeatable, automated way.

Feel free to clone, fork, copy/paste as much as you want from this repo.

## To use:

Make sure you have an AWS context set via the AWS CLI, and an active Kubernetes context set via `kubectl`.

1. Change the variables in `./vars-files/dvelopment.tfvars` to match your EKS region and cluster.
2. Change the variable string values in `main.tf`for the `ServiceAccount` name and target namespace; alternatively, you can add those to `./vars.tf` and set them as top-level variables as well.
3. Run `tofu init` to install providers and the demo module.
4. Run `tofu plan --var-file ./vars-files/development.tfvars` to see the resources that will be created.
5. Run `tofu apply --var-file ./vars-files/development.tfvars` to create the resources.
6. Run `tofu destroy --var-file ./vars-files/development.tfvars` to tear everything down.