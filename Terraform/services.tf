resource "kubernetes_service" "services" {
  for_each = var.svc-data
  metadata {
    name      = each.value.name
    namespace = var.ns-names[each.value.namespace]
    labels = each.value.labels
  }
  spec {
    selector = each.value.labels
    port {
      port        = each.value.port
      target_port = each.value.target_port
    }
    type = each.value.type
  }
}
