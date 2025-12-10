resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.19.0"
  namespace  = "kube-system"
  upgrade_install = true

  values = [
    file("values/externaldns.yaml")
  ]
}