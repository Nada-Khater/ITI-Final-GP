resource "kubernetes_cluster_role" "jenkins_role" {
  metadata {
    name      = "jenkins-role"
  }
  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_role_binding" {
  metadata {
    name      = "jenkins_role_binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_cluster_role.jenkins_role.metadata[0].name
    namespace = var.ns-names[1]
  }

  role_ref {
    kind     = "ClusterRole"
    name     = kubernetes_cluster_role.jenkins_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}