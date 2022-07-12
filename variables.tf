variable "region" {
    type = string
    description = "Region of your RDS instance"  
}

variable "original_instance_name" {
    type = string
    description = "Name of the source instance"  
}

variable "db_sg_id" {
    type = string
    description = "Security group to ensure access from kubernetes/internet"  
}