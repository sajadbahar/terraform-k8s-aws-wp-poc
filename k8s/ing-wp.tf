#
## WordPress Ingress
#
resource "kubernetes_ingress_v1" "kube-wp" {
depends_on = [
kubernetes_service.kube-wp]
  metadata {
    name = "kube-wp"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "blog.${var.stage-domain}"

      http {
        path {
          path = "/"
          backend {
            service {
              name = "kube-wp"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
