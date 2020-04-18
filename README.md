1. Clone the repository

2. Ensure, that you have permissions to create VPC, EC2 and IAM resources.

  This was tested with [shared credentials](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file), but any other [method of authentication](https://www.terraform.io/docs/providers/aws/index.html#authentication) is fine too.

3. Export the name of your Key Pair for Jenkins:

`export TF_VAR_key_name=you_aws_key_pair_name`

If you wish to restrict access for SSH (and for the Jenkins web interface as well), you may use `TF_VAR_allow_ssh_from` environment variable, e.g.:

`export TF_VAR_allow_ssh_from=$(curl -s https://ifconfig.co)/32`

That will restrict access to the host it is executed from.

4. Run:
```
cd terraform
terraform init ecs/
terraform apply -auto-approve \
                -var-file=vars.tfvars \
                -state=ecs/terraform.tfstate ecs/ && \
cd ..
```
