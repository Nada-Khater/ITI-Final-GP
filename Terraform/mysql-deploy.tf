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
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "Mysql_RootPassword"
              }
            }
          }
          env {
            name  = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "Mysql_dbname"
              }
            }
          }
          env {
            name  = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "UserName"
              }
            }
          }
          env {
            name  = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "UserPassword"
              }
            }
          }
          port {
            container_port = 3306
          }
        }
      }
    }
  }
}
