locals {
 name_prefix = "nandini"
}


resource "aws_iam_role" "role_example" {
 name = "${local.name_prefix}-role-example"


 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Sid    = ""
       Principal = {
         Service = "ec2.amazonaws.com"
       }
     },
   ]
 })
}


data "aws_iam_policy_document" "policy_example" {
 statement {
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }
 statement {
   effect    = "Allow"
   actions   = ["s3:ListBucket"]
   resources = ["*"]
 }
}


resource "aws_iam_policy" "policy_example" {
 name = "${local.name_prefix}-policy-example"


 ## Option 1: Attach data block policy document
 policy = data.aws_iam_policy_document.policy_example.json


}


resource "aws_iam_role_policy_attachment" "attach_example" {
 role       = aws_iam_role.role_example.name
 policy_arn = aws_iam_policy.policy_example.arn
}


resource "aws_iam_instance_profile" "profile_example" {
 name = "${local.name_prefix}-profile-example"
 role = aws_iam_role.role_example.name
}

module "web_app" {
 source = "./modules/web_app"

 name_prefix = "nandini" 

 instance_type  = "t2.micro"
 instance_count = 2

 vpc_id        = "vpc-07d6f651aa45295df"
 public_subnet = false
}