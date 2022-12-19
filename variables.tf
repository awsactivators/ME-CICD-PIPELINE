variable "region" {
  default = "us-east-2"
}

variable "project_name" {
  type        = string
  description = "This is the project name"
  default     = "macro-eyes"
}

#VPC variable Cidr configuration

variable "vpc_cidr" {
  type        = string
  description = "This is the vpc cidr"
  default     = "10.0.0.0/16"
}

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}


#AZ 2a Cidr Block variables configuration

variable "Public_ALB_NAT_1_Sub_Cidr" {
  type        = string
  description = "This is the public ALB/NAT subnet 1 cidr"
  default     = "10.0.1.0/24"
}

variable "Private_Web_1_Sub_Cidr" {
  type        = string
  description = "This is the private web subnet 2 cidr"
  default     = "10.0.2.0/24"
}

variable "Private_DB_1_Sub_Cidr" {
  type        = string
  description = "This is the private DB subnet 3 cidr"
  default     = "10.0.3.0/24"
}


#AZ 2b Cidr Block variables configuration

variable "Public_ALB_NAT_2_Sub_Cidr" {
  type        = string
  description = "This is the public ALB/NAT subnet 4 cidr"
  default     = "10.0.4.0/24"
}

variable "Private_Web_2_Sub_Cidr" {
  type        = string
  description = "This is the private web subnet 5 cidr"
  default     = "10.0.5.0/24"
}

variable "Private_DB_2_Sub_Cidr" {
  type        = string
  description = "This is the private DB subnet 6 cidr"
  default     = "10.0.6.0/24"
}

variable "jenkins-prod-ami" {
  default = "ami-0f924dc71d44d23e2"
}

variable "sonar-ami" {
  default = "ami-0a59f0e26c55590e9"
}


variable "prometheus-grafana-ami" {
  default = "ami-0d5bf08bc8017c83b"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_pair" {
  default = "macro-eyes"
}

variable "jenkins-sg-desc" {
  default = "This is Jenkins sg description"
}

variable "prometheus-sg-desc" {
  default = "This is the security group of prometheus, port 9090 and 22"
}

variable "grafana-sg-desc" {
  default = "This is the security group of grafana, port 3000 and 22"
}

variable "prod-sg-desc" {
  default = "This is the security group of the prod environment, port 9100 and 22"
}
