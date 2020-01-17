resource "aws_vpc" "vpc-sid" {
  cidr_block = "10.0.0.0/16"
  tags = {

    Name = "test-vpc"
  }
}
resource "aws_subnet" "subnet-1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = "${aws_vpc.vpc-sid.id}"
  tags = {

    Name = "test-subnet"
  }
}
resource "aws_key_pair" "test-key" {
  key_name   = "key-aws"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApc3E8HoYn2Zuwunb2nKj0kOaZIVw4tbgdGgyoU+Pn2XpzBppKhc4YwEJaCQFelMmTAf/PkGHgzBQGUUEANxnggLJiRr1gqKeqO6tc2MXRa7nvC1ZQ5AzNvBPcjCwzA3R4WjVXiwgVfNs/HkV4UFXWb4xuA7lDqFDkd+pU/Pgc1xBUUB09Vhy5Cb++eTRov52xVsaW7N9B2gi8CUH51DHViP/2S/Ok6rbMGy4lTl7+m6H7o78qlcQ6CTadCtMOUXzQwFFvly5Zi81PP7EDeQkddJZ/tjyRD8dqJaHC+LAWZ1xc38tDYxs8RO8VIjxl6rsbh0lvlGW0sJPYcf86iJs7Q== rsa-key-20200111"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc-sid.id}"

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "routetable-sid" {
  vpc_id = "${aws_vpc.vpc-sid.id}"
  tags = {
    Name = "terraform-rt"
  }

}

resource "aws_route" "route-sid" {
  route_table_id         = "${aws_route_table.routetable-sid.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}
resource "aws_security_group" "sg-sid" {
  vpc_id = "${aws_vpc.vpc-sid.id}"
  tags = {

    Name = "sg"
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id = "${aws_vpc.vpc-sid.id}"
  #subnet_id = "${aws_subnet.subnet-1.id}"
  route_table_id = "${aws_route_table.routetable-sid.id}"
}
resource "aws_route_table_association" "subnet" {
  subnet_id      = "${aws_subnet.subnet-1.id}"
  route_table_id = "${aws_route_table.routetable-sid.id}"
}

resource "aws_instance" "instance" {
  count                       = "${var.instance_count}"
  ami                         = "${lookup(var.ami, var.region)}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.sg-sid.id}"]
  key_name                    = "${aws_key_pair.test-key.key_name}"
  subnet_id                   = "${aws_subnet.subnet-1.id}"
  associate_public_ip_address = true
  user_data                   = "${file("script.sh")}"
  tags = {

    Name = "tf-instance-${element(var.instance_tags, count.index)}"
  }
}
