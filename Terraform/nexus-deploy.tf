resource "kubernetes_deployment" "nexus" {
  metadata {
    name      = "nexus"
    namespace = var.ns-names[1]
    labels = {
      app = "nexus"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nexus"
      }
    }
    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }
      spec {
        container {
          name  = "nexus"
          image = "sonatype/nexus3"
          port {
            container_port = 8081
          }
          volume_mount {
            name       = "nexus-storage"
            mount_path = "/nexus-data"
          }
        }
        volume {
          name = "nexus-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pvc["nexus"].metadata[0].name
          }
        }
      }
    }
  }
}