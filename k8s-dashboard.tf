# Give cluster-admin permissions to K8S Dashboard #

# Kubernetes Service account for K8S Dashboard
# resource "kubernetes_service_account" "Terra-kubernetes-dashboard-serviceaccount" {
#   metadata {
#     name      = "kubernetes-dashboard"
#     namespace = "kube-system"
#   }
# }

# Binding cluster-admin role at the Cluster Level for Helm Service Account
resource "kubernetes_cluster_role_binding" "Terra-kubernetes-dashboard-clusterrolebinding" {
  metadata {
    name = "kubernetes-dashboard"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard"
    namespace = "kube-system"
  }
}
