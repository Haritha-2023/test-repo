variable "prefix" {
  description = "This prefix will be included in the name of most resources."
  default = "samg"
}

variable "location" {
  description = "The region"
  default     = "centralus"
}

variable "cluster_name" {
  description = "A name for the cluster."
  type        = string
  default     = "My Cluster"
}

variable "cluster_autotermination_minutes" {
  description = "How many minutes before automatically terminating due to inactivity."
  type        = number
  default     = 60
}

variable "cluster_num_workers" {
  description = "The number of workers."
  type        = number
  default     = 1
}

variable "node_type_id" {
  description = "Type of worker nodes for databricks clusters"
  default     = "Standard_DS3_v2"
}

variable "spark_version" {
  description = "Spark Runtime Version for databricks clusters"
  default     = "7.3.x-scala2.12"
}

