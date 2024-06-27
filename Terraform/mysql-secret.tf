resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = var.ns-names[0]  // dev ns
  }

  type = "Opaque"

  data = {
    "Mysql_RootPassword" = base64encode(var.mysql_root_password)
    "Mysql_dbname"       = base64encode(var.mysql_db_name)
    "UserName"           = base64encode(var.mysql_user_name)
    "UserPassword"       = base64encode(var.mysql_user_password)
  }
}
