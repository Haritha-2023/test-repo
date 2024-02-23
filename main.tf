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



resource "databricks_cluster" "this" {
  cluster_name            = var.cluster_name
  node_type_id            = data.databricks_node_type.smallest.id
  spark_version           = data.databricks_spark_version.latest_lts.id
  autotermination_minutes = var.cluster_autotermination_minutes
  num_workers             = var.cluster_num_workers
}

output "cluster_url" {
 value = databricks_cluster.this.url
}

resource "databricks_notebook" "notebook" {
  content = base64encode("print('Welcome to your Python notebook')")
  path = var.notebook_path
  overwrite = false
  mkdirs = true
  language = "PYTHON"
  format = "SOURCE"
}

resource "databricks_job" "myjob" {
    name = "Featurization"
    timeout_seconds = 3600
    max_retries = 1
    max_concurrent_runs = 1
    existing_cluster_id = databricks_cluster.shared_autoscaling.id

    notebook_task {
        notebook_path = var.notebook_path
    }

    library {
        pypi {
            package = "fbprophet==0.6"
        }
    }

    email_notifications {
        no_alert_for_skipped_runs = true
    }
}
