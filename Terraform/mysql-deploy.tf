resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = var.ns-names[0]  // dev ns
    labels = {
      app = "mysql"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        container {
          name  = "mysql"
          image = "mysql:5.7"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          }
          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_db_name
          }
          env {
            name  = "MYSQL_USER"
            value = var.mysql_user_name
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = var.mysql_user_password
          }
          port {
            container_port = 3306
          }
        }
      }
    }
  }
}
