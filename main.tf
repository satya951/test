resource "tls_private_key" "keyname" {
 algorithm = "RSA"
}
resource "aws_key_pair" "generated_key" {
 key_name = "keyname23"
 public_key = "${tls_private_key.keyname.public_key_openssh}"
 depends_on = [
  tls_private_key.keyname
 ]
}
resource "local_file" "key" {
 content = "${tls_private_key.keyname.private_key_pem}"
 filename = "keyname.pem"
 file_permission ="0400"
 depends_on = [
  tls_private_key.keyname
 ]
}

resource "aws_vpc" "vpc_name" {
 cidr_block = "10.0.0.0/16"
 instance_tenancy = "default"
 enable_dns_hostnames = "true"
 
 tags = {
  Name = "vpc_name-test"
 }
}


resource "aws_security_group" "sg_name" {
 name = "sg_name"
 description = "This firewall allows SSH, HTTP and MYSQL"
 vpc_id = "${aws_vpc.vpc_name.id}"
 
 ingress {
  description = "SSH"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress { 
  description = "HTTP"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress {
  description = "TCP"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 
 tags = {
  Name = "sg_name"
 }
}


resource "aws_subnet" "public" {
 vpc_id = "${aws_vpc.vpc_name.id}"
 cidr_block = "192.168.0.0/24"
 availability_zone = "ap-south-1a"
 map_public_ip_on_launch = "true"
 
 tags = {
  Name = "my_public_subnet"
 } 
}
resource "aws_subnet" "private" {
 vpc_id = "${aws_vpc.vpc_name.id}"
 cidr_block = "192.168.1.0/24"
 availability_zone = "ap-south-1b"
 
 tags = {
  Name = "my_private_subnet"
 }
}


resource "aws_internet_gateway" "internet_gateway_name" {
 vpc_id = "${aws_vpc.vpc_name.id}"
 
 tags = { 
  Name = "<internet_gateway_name>"
 }
}


resource "aws_route_table" "name_of_rt" {
 vpc_id = "${aws_vpc.vpc_name.id}"
 
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet_gateway_name.id}"
 }
 
 tags = {
  Name = "name_of_rt"
 }
}

resource "aws_route_table_association" "a" {
 subnet_id = "${aws_subnet.public.id}"
 route_table_id = "${aws_route_table.name_of_rt.id}"
}
resource "aws_route_table_association" "b" {
 subnet_id = "${aws_subnet.private.id}"
 route_table_id = "${aws_route_table.name_of_rt.id}"
}


resource "aws_instance" "wordpress" {
 ami = "ami-03a115bbd6928e698"
 instance_type = "t2.micro"
 key_name = "${aws_key_pair.generated_key.key_name}"
 vpc_security_group_ids = [ "${aws_security_group.sg_name.id}" ]
 subnet_id = "${aws_subnet.public.id}"
 
 tags = {
  Name = "<Wordpress_instance_name>"
 }
}


resource "aws_instance" "mysql" {
 ami = "ami-04e98b8bcc00d2678"
 instance_type = "t2.micro"
 key_name = "${aws_key_pair.generated_key.key_name}"
 vpc_security_group_ids = [ "${aws_security_group.sg_name.id}" ]
 subnet_id = "${aws_subnet.private.id}"
  
 tags = {
  Name = "MySQL_instance_name"
 }
}