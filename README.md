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

5. Make sure whenever you make changes to the code run the `terraform init -upgrade` command from the root of the repository.
6. Try to access the website using ALB DNS Name either through HTTP(80) or HTTPS(443).


# Ansible Playbook to configure web-app
1. Create an inventory file to add the list of hosts.
2. Create an Ansible Playbook for installing web server and copy the source file(web app) to the destination path `(/var/www/html/index.html)`.
3. Run the playbook using the ansible command: `ansible-playbook -i inventory playbook.yaml`
