resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = var.ns-names[0]  // dev ns
  }

  type = "Opaque"

  data = {
    "Mysql_RootPassword" = var.mysql_root_password
    "Mysql_dbname"       = var.mysql_db_name
    "UserName"           = var.mysql_user_name
    "UserPassword"       = var.mysql_user_password
  }
}
