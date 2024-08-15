
# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2s"
    node_count = var.node_count
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  } 

}




















































































# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "tonynoah-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["eu-north-1a", "eu-north-1b"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

#   enable_nat_gateway = true
#   single_nat_gateway = true
#   enable_dns_hostnames = true

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "tonynoah234"
#   cluster_version = "1.30"

#   cluster_endpoint_public_access  = true

#   # cluster_addons = {
#   #   coredns                = {}
#   #   eks-pod-identity-agent = {}
#   #   kube-proxy             = {}
#   #   vpc-cni                = {}
#   # }

#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.private_subnets


#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     ami_type = "AL2_x86_64"
#   }

#   eks_managed_node_groups = {
#     node1 = {
#         name = "node-1"
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       instance_types = ["t3.medium"]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 2
#     }

# node2 = {
#     name = "node-2"
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       instance_types = ["t3.medium"]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 2
#     }
  
#   }

#   # Cluster access entry
#   # To add the current caller identity as an administrator
#   enable_cluster_creator_admin_permissions = true
# }
