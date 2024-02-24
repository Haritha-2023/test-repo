terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"      
    }
    azurerm = {
      source = "hashicorp/azurerm"      
    }
  }
  cloud {
    organization = "AzureDatabricks"
    workspaces {
      name = "Azure-cluster"
    }
  }
}


##
provider "azurerm" {
    features {}
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.myworkspace.id
}


resource "azurerm_resource_group" "myresourcegroup" {
  name     = "${var.prefix}-myresourcegroup"
  location = var.location
}

resource "azurerm_databricks_workspace" "myworkspace" {
  location                      = azurerm_resource_group.myresourcegroup.location
  name                          = "${var.prefix}-workspace"
  resource_group_name           = azurerm_resource_group.myresourcegroup.name
  sku                           = "trial"
}

# Create the cluster with the "smallest" amount
# of resources allowed.
data "databricks_node_type" "smallest" {
  local_disk = true
}

# Use the latest Databricks Runtime
# Long Term Support (LTS) version.
#data "databricks_spark_version" "latest_lts" {
#  long_term_support = true
#}

resource "databricks_cluster" "this" {
  cluster_name            = var.cluster_name
  node_type_id            = var.node_type_id
  spark_version           = var.spark_version
  autotermination_minutes = var.cluster_autotermination_minutes
  num_workers             = var.cluster_num_workers
}

output "cluster_url" {
 value = databricks_cluster.this.url
}

