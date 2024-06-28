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
        service_account_name = kubernetes_service_account.jenkins-SA.metadata[0].name
        container {
          name  = "jenkins"
          image = "nadakhater/jenkinsgp:latest"
          port {
            container_port = 8080
          }
          volume_mount {
            name       = "jenkins-storage"
            mount_path = "/var/jenkins_home"
          }
          volume_mount {
            name       = "docker-socket"
            mount_path = "/var/run/docker.sock"
          }
        }
        volume {
          name = "jenkins-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pvc["jenkins"].metadata[0].name
          }
        }
         volume {
          name = "docker-socket"
          host_path {
            path = "/var/run/docker.sock"
          }
        }
      }
    }
  }
}
