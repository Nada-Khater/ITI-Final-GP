resource "kubernetes_namespace" "ns" {
  count = length(var.ns-names)
  metadata {
    name = var.ns-names[count.index]
  }
}
