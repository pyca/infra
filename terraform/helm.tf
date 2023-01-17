resource "helm_release" "cm" {
  count            = 1
  name             = "cm"
  namespace        = "cert-manager"
  create_namespace = true
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "v1.11.0"
  values = [<<EOF
    global:
      podSecurityPolicy:
        enabled: true
        useAppArmor: true
    prometheus:
      enabled: false
    installCRDs: true
  EOF
  ]
  depends_on = [resource.oci_containerengine_node_pool.create_node_pool_details0]
}


resource "helm_release" "actions-runner-controller" {
  count            = 1
  name             = "actions-runner-controller"
  namespace        = "actions-runner-system"
  create_namespace = true
  chart            = "actions-runner-controller"
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  version          = "v0.21.1"
  values = [
    "${file("values.yaml")}"
  ]
  depends_on = [resource.helm_release.cm]
}