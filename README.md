# Mounting AWS Secrets as a Volume

This repo serves as a demo to accompany [this blog post](https://colinj.hashnode.dev/mounting-aws-secrets-as-volumes-in-eks). It expands on [another repo](https://github.com/colinjlacy/eks-iam-opentofu), which showed how to attach an IAM role to a Kubernetes `ServiceAccount`.

I broke apart the resource file in `/modules/service-role` so that each logical grouping of resources has its own file:
- `aws-sm-secret.tf` creates the secret and its contents
- `iam-role-and-policy.tf` creates the various iam-related resources
- `kubernetes-manifests.tf` creates the `ServiceAccount` and `SecretProviderClass`

Feel free to clone, fork, copy/paste as much as you want from this repo.

## To use:

Make sure you have an AWS context set via the AWS CLI, and an active Kubernetes context set via `kubectl`.

1. Change the variables in `./vars-files/dvelopment.tfvars` to match your EKS region and cluster.
2. Change the variable string values in `main.tf`for the `ServiceAccount` name and target namespace; alternatively, you can add those to `./vars.tf` and set them as top-level variables as well.
3. Run `tofu init` to install providers and the demo module.
4. Run `tofu plan --var-file ./vars-files/development.tfvars` to see the resources that will be created.
5. Run `tofu apply --var-file ./vars-files/development.tfvars` to create the resources.
6. Run `tofu destroy --var-file ./vars-files/development.tfvars` to tear everything down.