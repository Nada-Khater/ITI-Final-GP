resource "kubernetes_role" "jenkins_role" {
  metadata {
    name      = "jenkins-role"
    namespace = var.ns-names[1]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log", "services", "deployments", "configmaps", "secrets"]
    verbs      = ["get", "list", "create", "update", "delete"]
  }
}

resource "kubernetes_role_binding" "jenkins_role_binding" {
  metadata {
    name      = "jenkins_role_binding"
    namespace = var.ns-names[1]
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins-SA.metadata[0].name
    namespace = var.ns-names[1]
  }

  role_ref {
    kind     = "Role"
    name     = kubernetes_role.jenkins_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}