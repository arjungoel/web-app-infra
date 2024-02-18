# web-app-infra
1. Assume IAM Role.
2. Attach `AdministratorAccess` to the role to avoid access denied error.
3. Build the terraform module.
4. Run the following commands in a given sequence:
    - terraform fmt
    - terraform init
    - terraform plan
    - terraform apply -auto-approve

**NOTE**: Run the commands from the root of the directory.
