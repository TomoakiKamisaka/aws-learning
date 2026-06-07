variable "aws_region" {
    description = "AWSリージョン"
    type = string
    default = "ap-northeast-1"
} 

variable "project_name" {
    description = "プロジェクト名"
    type = string
    default = "handson"
    }

variable "vpc_cidr" {
    description = "VPCのCIDRブロック"
    type = string
    default = "10.0.0.0/16"
}
