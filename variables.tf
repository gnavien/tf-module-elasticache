variable "component" {}
variable "env" {}
variable "subnet_ids" {}
variable "tags" {}
variable "sg_subnet_cidr" {}
variable "kms_key_arn" {}
variable "engine" {}
variable "engine_version" {}
variable "node_type" {}
variable "port" {
  default = 6379
}
variable "vpc_id" {}
variable "num_node_groups" {}
variable "replicas_per_node_group" {}