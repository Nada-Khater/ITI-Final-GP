variable "ns-names" {
  type = list(string)
  default = [ "dev", "tools" ]
}

variable "mysql_root_password" {
  type      = string
  sensitive = true
}

variable "mysql_db_name" {
  type      = string
  sensitive = true
}

variable "mysql_user_name" {
  type      = string
  sensitive = true
}

variable "mysql_user_password" {
  type      = string
  sensitive = true
}

variable "pv-data" {
  type = map(object({
    storage      = string
    path         = string
    access_modes = list(string)
  }))
  default = {
    jenkins = {
      storage      = "10Gi"
      path         = "/mnt/data/jenkins"
      access_modes = ["ReadWriteOnce"]
    }
    nexus = {
      storage      = "10Gi"
      path         = "/mnt/data/nexus"
      access_modes = ["ReadWriteOnce"]
    }
  }
}

variable "svc-data" {
  type = map(object({
    name        = string
    port        = number
    target_port = number
    type        = string
    labels      = map(string)
    namespace   = number
  }))
  default = {
    jenkins = {
      name        = "jenkins"
      port        = 80
      target_port = 8080
      namespace   = 1     // tools ns
      type        = "NodePort"
      labels      = {
        app = "jenkins"
      }
      
    }
    nexus = {
      name        = "nexus"
      port        = 80
      target_port = 8081
      namespace   = 1     // tools ns
      type        = "NodePort"
      labels      = {
        app = "nexus"
      }
    }

    mysql = {
      name        = "mysql"
      port        = 3306
      target_port = 3306
      namespace   = 0     // dev ns
      type        = "ClusterIP"
      labels      = {
        app = "mysql"
      }
    }

    nodejs = {
      name        = "nodejs"
      port        = 80
      target_port = 3000
      namespace   = 0     // dev ns
      type        = "NodePort"
      labels      = {
        app = "nodejs"
      }
    }

    nexus_repo = {
      name = "docker"
      port = 5000
      target_port = 5000
      namespace = 1 // tools ns
      type = "ClusterIP"
      labels = {
      app = "nexus" 
    }

    }
  }
}
