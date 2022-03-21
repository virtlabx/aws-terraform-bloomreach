output "cluster_endpoint" {
  value = module.eks-cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks-cluster.cluster_security_group_id
}

output "aws_auth_configmap" {
  description = "A kubernetes configuration to authenticate to this EKS cluster"
  value       = module.eks-cluster.aws_auth_configmap_yaml
}