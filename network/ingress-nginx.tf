resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.11.0"
  
  namespace  = "ingress-nginx"
  create_namespace = true
  upgrade_install = true
  
  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "controller.service.loadBalancerIP"
      value = "10.0.1.130"
    },
    {
      name  = "controller.metrics.enabled=true"
      value = true
    },
    {
      name  = "controller.podAnnotations.prometheus.io/scrape"
      value = true
    },
    {
      name  = "controller.podAnnotations.prometheus.io/port"
      value = 10254
    },
    {
      name  = "controller.allowSnippetAnnotations"
      value = true
    },
    {
      name  = "controller.replicaCount"
      value = 2
    },
  ]
}