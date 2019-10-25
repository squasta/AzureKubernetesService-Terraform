# Azure Kubernetes Service Cluster deployment with Terraform


= Tested with success with Terraform v0.12.12 + Azurerm provider version v1.35.0 + Kubernetes provider v1.9.0

--------------------------------------------------------------------------------------------------------

This is a set of Terraform files used to deploy an Azure Kubernetes Cluster with all new fall 2019 features :

- Nodes will be dispatched in different Availability Zones (AZ)
- Node pools will support Autoscaling
- Different node pools :  Linux Nodes & Windows Nodes

These Terraform files can be used to deploy the following Azure components :
- An Azure Resource Group
- An Azure Kubernetes Services Cluster with 2 node pools : one Linux and one Windows
- An Azure Load Balancer Standard SKU
- A Virtual Network with it Subnets
- An Azure Log Analytics Workspace + Containers solutions

On Kubernetes, these Terraform files will :
- Create a Tiller service account and a ClusterRole Binding
- Create a ClusterRole Binding to give cluster-admin permissions to Kubernetes-Dashboard

__Prerequisites :__
- An Azure Subscription with enough privileges (create RG, AKS...)
- Azure CLI 2.0.75 : https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
   And you need to activate features that are still in preview : https://github.com/squasta/AzureKubernetesService-Labs/blob/master/0-PrepareAzure.txt
- Terraform CLI 0.12.12 or > : https://www.terraform.io/downloads.html

__To deploy this infrastructure :__
1. Log to your Azure subscription (az login)
2. Create an Azure Key Vault and create all secrets defined in datasource.tf
3. Define the value of each variable in .tf and .tfvars files
4. Initialize your terraform deployment : terraform init
5. Plan your terraform deployment : `terraform plan --var-file=myconf.tfvars`
6. Apply your terraform deployment : `terraform apply --var-file=myconf.tfvars`

__For more information about Terraform & Azure, few additional online resources :__
- My blog : https://stanislas.io
- Julien's blog : https://blog.jcorioland.io/
- Terraform documentation : https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html
- Azure Terraform Provider : https://github.com/terraform-providers/terraform-provider-azurerm
- Azure Terraform Provider AKS Cluster : https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/azurerm/resource_arm_kubernetes_cluster.go

After deployment is succeeded, you can check your cluster using portal or better with azure cli and the following command: 
`az aks show --resource-group NAMEOFYOURRESOURCEGROUP --name NAMEOFYOURAKSCLUSTER -o jsonc`

Get your kubeconfig using :

`az aks get-credentials --resource-group NAMEOFYOURRESOURCEGROUP --name NAMEOFYOURAKSCLUSTER --admin`

Connect to Kubernetes Dashboard :

`az aks browse --resource-group NAMEOFYOURRESOURCEGROUP --name NAMEOFYOURAKSCLUSTER`

Then open a browser and go to http://127.0.0.1:8001

![Magic](https://github.com/squasta/AzureKubernetesService-Terraform/raw/master/Magic.gif)



