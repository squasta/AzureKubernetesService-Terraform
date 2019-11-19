
# More info about azurerm_kubernetes_cluster resource :
# see https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/azurerm/resource_arm_kubernetes_cluster.go
resource "azurerm_kubernetes_cluster" "Terra_aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.Terra_aks_rg.location
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  dns_prefix          = var.dns_name
  kubernetes_version  = var.kubernetes_version

  dynamic "agent_pool_profile" {
    for_each = var.agent_pools
    iterator = pool
    content {
      name            = pool.value.name
      # count           = pool.value.count            # use this parameter if you want a static number of nodes. Must be between 1 to 100
      enable_auto_scaling = true                      # use this parameter if you want an AKS Cluster with Node autoscale. Need also min_count and max_count
      min_count           = pool.value.min_count      # minimum number of nodes with AKS Autoscaler
      max_count           = pool.value.max_count      # maximum number of nodes with AKS Autoscaler
      vm_size         = pool.value.vm_size
      availability_zones = pool.value.availability_zones  # example : [1, 2, 3]
      os_type         = pool.value.os_type  # example :linux, windows
      os_disk_size_gb = pool.value.os_disk_size_gb
      type            = pool.value.type
      max_pods        = pool.value.max_pods   # between 30 and 100
      vnet_subnet_id  = azurerm_subnet.Terra_aks_subnet.id
      node_taints     = pool.value.node_taints        # cf. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
    }
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = data.azurerm_key_vault_secret.ssh_public_key.value
    }
  }

  windows_profile {
    admin_username = var.windows_admin_username
    # Windows admin password is stored as a secret in an Azure Keyvault. Check datasource.tf for more information
    admin_password = data.azurerm_key_vault_secret.windows_admin_password.value
  }

  network_profile {
    network_plugin     = "azure" # Can be kubenet (Basic Network) or azure (=Advanced Network)
    network_policy     = "azure"     # Options are calico or azure - only if network plugin is set to azure
    dns_service_ip     = "172.16.0.10" # Required when network plugin is set to azure, must be in the range of service_cidr and above 1
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "172.16.0.0/16" # Must not overlap any address from the VNet
    load_balancer_sku  = "Standard" # sku can be basic or standard. Here it an AKS cluster with AZ support so Standard SKU is mandatory
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.Terra-LogsWorkspace.id
    }
  }

  # Enable Kubernetes RBAC 
  role_based_access_control {
    enabled = true
  }

  # Service Principal is mandatory because Kubernetes will provision some Azure Resources like Azure Load Balancer, Public IP, Managed Disks... 
  service_principal {
    client_id     = data.azurerm_key_vault_secret.spn_id.value
    client_secret = data.azurerm_key_vault_secret.spn_secret.value
  }

  tags = {
    Usage = "Demo"
    Environment = "Demo"
  }
}

# output "client_certificate" {
#   value = "${azurerm_kubernetes_cluster.Terra_aks.kube_config.0.client_certificate}"
# }

# output "kube_config" {
#   value = "${azurerm_kubernetes_cluster.Terra_aks_rg.kube_config_raw}"
# }

