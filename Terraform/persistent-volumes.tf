resource "kubernetes_persistent_volume" "pv" {
  for_each = var.pv-data
  metadata {
    name = "${each.key}-pv"
  }
  spec {
    capacity = {
      storage = each.value.storage
    }
    access_modes = each.value.access_modes
    persistent_volume_source {
      host_path {
        path = each.value.path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = var.pv-data
  metadata {
    name      = "${each.key}-pvc"
    namespace = var.ns-names[1]
  }
  spec {
    access_modes = each.value.access_modes
    resources {
      requests = {
        storage = each.value.storage
      }
    }
  }
}

