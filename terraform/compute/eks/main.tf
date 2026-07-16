module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.34"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  enable_cluster_creator_admin_permissions = true

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true


  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.small"]

      min_size     = 3
      max_size     = 3
      desired_size = 3

      security_group_rules = {
        egress_all = {
          description = "Allow all outbound traffic"
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  tags = {
    Project = "incident-tracker"
  }
}
