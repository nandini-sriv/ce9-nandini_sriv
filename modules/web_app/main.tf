resource "aws_instance" "web_app" {
 count = 2

 ami                    = "ami-0ac4dfaf1c5c0cce9"
 instance_type          = "${var.instance_type}"
 subnet_id              = data.aws_subnets.public.ids[count.index % length(data.aws_subnets.public.ids)]
 vpc_security_group_ids = [aws_security_group.web_app.id]
 user_data = templatefile("${path.module}/init-script.sh", {
   file_content = "webapp-#${count.index}"
 })

 associate_public_ip_address = true
 tags = {
   Name = "${var.name_prefix}-webapp-${count.index}"
 }
}

resource "aws_security_group" "web_app" {
 name_prefix = "${var.name_prefix}-webapp"
 description = "Allow traffic to webapp"
 vpc_id      = data.aws_vpc.selected.id

 ingress {
   from_port        = 80
   to_port          = 80
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }

 egress {
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }

lifecycle {
   create_before_destroy = true
 }
}

