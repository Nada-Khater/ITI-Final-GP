resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = var.ns-names[1]
    labels = {
      app = "jenkins"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"
          port {
            container_port = 8080
          }
          volume_mount {
            name       = "jenkins-storage"
            mount_path = "/var/jenkins_home"
          }
        }
        volume {
          name = "jenkins-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pvc["jenkins"].metadata[0].name
          }
        }
      }
    }
  }
}
