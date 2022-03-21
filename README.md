# terraform-bloomreach
Terraform code to provision all AWS resources.

## Modules
- EC2
- IAM
- SNS
- Tagging

### EC2 Module
Generic EC2 module to provision EC2 instances, its volume and its route53 record.

It uses cloud-init to optionally install some packages during the ec2 instance provisioning.

Packages are Docker, Jenkins, git and cloudwatch agent.

### IAM Module
To provision Admins group with AdministratorAccess policy and other default policies that also could be attached to any other group by default.

Applying Force MFA on users is mandatory as a security best practice. 

### SNS Module
To provision a sns topic and a topic subscription.

### Tagging Module
To define a generic tags that could be used for all terraform resources.

This is useful in calculating billing for a specific services/domains in AWS.

### Terraform resources

I used Ireland region to provision all the resources.

- SNS module to create the sns topic.
- cloudwatch log group with 18 months retention period. 
- cloudwatch log metric filter for console sign-in without MFA.
- cloudwatch metric alarm to report single-factor console logins.
- Dynamodb table for locking terraform state file.
- Main file that has terraform backend, providers, availability zones ..etc
- Encrypted S3 bucket for the backend which has a lifecycle rule.
- Using IAM module to create 1 service user "k8s-user". (AK and SK are in the email attached link).
- VPC that has 3 private subnets and 3 public subnets in each AZ.
- KMS key to encrypt EKS cluster config.
- EKS cluster with an encrypted config(Security best practise).
- Imported AWS ssh public Key pair.
- Route53 domain for EC2 instance.
- Security group for jenkins EC2 instance with the required ports only opened.
- EC2 instance that runs jenkins and uses an EIP.
- IAM account password policy that is better for security.
- IAM role for cloudwatch agent that is installed in the ec2 instance and IAM instance profile.

### Run terraform:
There are 2 ways to do that.

1- Manually.

```
    git clone https://github.com/virtlabx/terraform-bloomreach.git
    cd terraform-bloomreach/aws-dev/ireland
    export export AWS_ACCESS_KEY_ID=<Access_key_placeholder>
    export AWS_SECRET_ACCESS_KEY=<Secret_key_placeholder>
    terraform init
    terraform plan
    terraform apply
    teraform destroy (For resources removal)
```

2- Automatically using GitHub action that detects the changes and applies it.

Terraform workflow triggers the push or pull request events but only for the main branch.

To check that, have a look on .github/workflows/terraform.yml file and also on Actions tab.

Here is the theory behind that:

[https://learn.hashicorp.com/tutorials/terraform/github-actions](https://learn.hashicorp.com/tutorials/terraform/github-actions)