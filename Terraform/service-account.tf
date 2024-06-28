resource "kubernetes_service_account" "jenkins-SA" {
  metadata {
    name = "jenkins-service-account"
    namespace = var.ns-names[1]
  }
}

resource "kubernetes_secret" "jenkins-SA-secret" {
  metadata {
    namespace = var.ns-names[1]
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.jenkins-SA.metadata[0].name
    }
    generate_name = "jenkins-sa-secret"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}