data "aws_vpc" "selected" {
 id = var.vpc_id
}

data "aws_subnets" "public" {
 filter {
   name   = "vpc-id"
   values = [var.vpc_id]
 }
 filter {
   name   = "tag:Name"
   values = ["*public*"]
 }
}
