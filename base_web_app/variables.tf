variable "aws_access_key" {
    type = string
    description = "AWS Access Key"
    sensitive = true
}
variable "aws_secret_key" {
    type = string
    description = "AWS Secret Key"
    sensitive = true
}

variable "aws_region" {
    type = string
    description = "AWS region to use for resources"
    default = "us-east-1"
}
variable "enable_dns_hostnames" {
    type = string
    description = "AWS DNS hostname VPC"
    default = true
}

variable "aws_cidr_block" {
    type = string
    description = "AWS CIDR Block for vpc"
    default = "10.0.0.0/16"
}

variable "aws_vpc_subnet" {
    type = string
    description = "AWS VPC Subnet"
    default = "10.0.0.0/24"
}

variable "aws_map_public_ip_on_launch" {
    type = bool
    description = "AWS map public ip launch"
    default = true
}

variable "aws_instance_type" {
    type = string
    description = "AWS Instance type"
    default = "t3.micro"
}

variable "company" {
    type = string
    description = "Company name"
    default = "mycompany"
}

variable "project" {
    type = string   
    description = "Project name"
}

variable "billing_code" {
    type = string
    description = "Billing code"
}