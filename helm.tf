# Create the tiller RBAC permissions #

# Kubernetes Service account for Tiller (server component of Helm < 3.x)
resource "kubernetes_service_account" "Terra-tiller-serviceaccount" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

# Binding cluster-admin role at the Cluster Level for Helm Service Account
resource "kubernetes_cluster_role_binding" "Terra-tiller-clusterrolebinding" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.Terra-tiller-serviceaccount.metadata[0].name
    namespace = "kube-system"
  }
}
