cluster_name = "notejam-deployment"

# AWS CLI config profile
aws_profile = "terraform"
aws_region  = "eu-central-1"

ec2_key_name = "aws_key"
ec2_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTsYpT0rXXgtHASbCoN57goH14soYe3/WQ/Qhzi/fTBrJOcWVnQT3285WCUbcYjDp9/TVJsjA3oL8c312PXT3xe4KzTQywfAOGjZBUzT9xq7O5Cf2QFnU4r/OjENMtYBLuKcocsOvM0Fo8HsLYqKH4P4ljISphiDBjgAwNLdaJYXb54nE0YUUiTYpp3/FhL1tiR5q5cO5fY0xr2QcEFWpT2MBYZNd3vqS5smlpBLSb68UZi88hi5Pi4w8aXTu998t0Yo29beY/r8fnQPaKyxCeaxiYwD1DmSssODUq2oOTtSoF4NXXTXKl03BUEJqSvVTsZC35nDWna3u5naeIIUyz ubuntu@ip-172-31-16-120"

vpc_cidr                 = "10.10.0.0/16"
vpc_az1                  = "eu-central-1a"
vpc_az2                  = "eu-central-1b"
vpc_public_subnet1_cidr  = "10.10.10.0/24"
vpc_public_subnet2_cidr  = "10.10.20.0/24"
vpc_private_subnet1_cidr = "10.10.11.0/24"
vpc_private_subnet2_cidr = "10.10.21.0/24"

db_multi_az            = true
db_skip_final_snapshot = true
db_storage_size_in_gb  = 40

k8s_desired_size        = 2
k8s_max_size            = 2
k8s_min_size            = 1
k8s_node_instance_types = ["t2.small"]
