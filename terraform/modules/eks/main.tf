# -------------------------------
# EKS CLUSTER IAM ROLE
# -------------------------------

# Allows the EKS service to assume this role.
data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# IAM role used by the EKS control plane.
resource "aws_iam_role" "cluster" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

# Grants the EKS control plane its required permissions.
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# -------------------------------
# EKS NODE GROUP IAM ROLE
# -------------------------------

# Allows EC2 instances to assume the worker-node role.
data "aws_iam_policy_document" "node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role used by EC2 worker nodes.
resource "aws_iam_role" "node" {
  name               = "${var.cluster_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
}

# Allows worker nodes to communicate with EKS.
resource "aws_iam_role_policy_attachment" "worker_node" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Allows worker nodes to pull images from ECR.
resource "aws_iam_role_policy_attachment" "ecr_pull" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

# Allows the Amazon VPC CNI plugin to manage pod networking.
resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# -------------------------------
# EKS CLUSTER
# -------------------------------

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version

  # Network configuration for the EKS control plane.
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true

    # Restrict public Kubernetes API access to your IP.
    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  # Use the modern EKS access API and grant the creator admin access.
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Wait for the cluster IAM permissions to be attached.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]

  tags = {
    Environment = var.environment
    Project     = "student-management"
  }
}

# -------------------------------
# EKS ADD-ONS
# -------------------------------

# Manages pod networking.
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"

  depends_on = [
    aws_eks_cluster.main
  ]
}

# Manages cluster DNS.
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_cluster.main
  ]
}

# Manages Kubernetes network rules.
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"

  depends_on = [
    aws_eks_cluster.main
  ]
}

# -------------------------------
# MANAGED NODE GROUP
# -------------------------------

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-workers"
  node_role_arn   = aws_iam_role.node.arn

  # Place worker nodes only in private application subnets.
  subnet_ids = var.private_subnet_ids

  # EC2 instance configuration.
  instance_types = ["t3.micro"]
  capacity_type  = "ON_DEMAND"
  ami_type       = "AL2023_x86_64_STANDARD"

  # Start with two nodes; allow scaling between one and three.
  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    Environment = var.environment
    Workload    = "student-management"
  }

  # Ensure the node IAM permissions are ready first.
  depends_on = [
    aws_iam_role_policy_attachment.worker_node,
    aws_iam_role_policy_attachment.ecr_pull,
    aws_iam_role_policy_attachment.cni
  ]

  tags = {
    Environment = var.environment
    Project     = "student-management"
  }
}