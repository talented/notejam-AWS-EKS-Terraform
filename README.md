# **Kubernetes Deployment of Notejam application on AWS EKS with Terraform**
Notejam flask application with postgres DB on RDS. Kubernetes Deployment on AWS EKS by provisioning with Terraform. Github Actions to build docker images to be pushed to AWS ECR.

## Architecture:
![Screenshot](aws_1.svg)

## Prerequisities:
- [Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04) & [Docker-compose](https://docs.docker.com/compose/install/)
- [AWS client Setup](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [Terraform]((https://www.terraform.io/downloads.html))
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [Helm](https://helm.sh/docs/intro/install/)


## Steps
1. Update terraform.tfvars with your own config variables and ssh-key. When ready, initiate terraform:
```
terraform -chdir=terraform init
```
2. Make all the scripts executable:
```
find . -maxdepth 1 -type f -name "*.sh" -exec chmod +x {} \;
```  
3. Create AWS Secret for DB Credentials: `./1_create_db_creds.sh`
4. Create Route 53 DNS Zone: `./2_route53.sh`
5. Provision AWS with terraform:
```
terraform -chdir=terraform apply
```
There is a bastion server provisioned as well to login to EKS worker nodes through private network. Login with your ssh-key that you've created:
```
ssh -i "ssh-key" ubuntu@$(terraform -chdir=terraform output -raw bastion_public_ip)
```
6. Kubectl config setup: `./3_EKS_setup.sh`





