variable "ns-names" {
  type = list(string)
  default = [ "dev", "tools" ]
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
    type = string
    labels      = map(string)
  }))
  default = {
    jenkins = {
      name        = "jenkins"
      port        = 80
      target_port = 8080
      type = "NodePort"
      labels      = {
        app = "jenkins"
      }
    }
    nexus = {
      name        = "nexus"
      port        = 80
      target_port = 8081
      type = "NodePort"
      labels      = {
        app = "nexus"
      }
    }
  }
}
