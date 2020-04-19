1. Clone the repository

2. Ensure, that you have permissions to create VPC, EC2, ECS, CloudWatch and IAM resources.

      This was tested with [shared credentials](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file), but any other [method of authentication](https://www.terraform.io/docs/providers/aws/index.html#authentication) will do.

      Ensure that you have terraform [installed](https://learn.hashicorp.com/terraform/getting-started/install.html#installing-terraform).

3. (Optional) To restrict web access, use `TF_VAR_allow_ssh_from` environment variable, e.g.:

      `export TF_VAR_allow_ssh_from=$(curl -s https://ifconfig.co)/32`

4. (Optional) To switch to EC2 launch type, execute `git checkout master`

5. Run:

      ```
      cd terraform
      terraform init ecs/
      terraform apply -auto-approve \
                      -var-file=vars.tfvars \
                      -state=ecs/terraform.tfstate ecs/ && \
      cd ..
```
