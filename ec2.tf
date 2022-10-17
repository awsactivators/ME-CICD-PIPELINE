resource "aws_key_pair" "macro_eyes_keypair" {
  key_name = "macro-eyes"
  public_key = "${file("./macro-eyes.pub")}"
}

resource "aws_instance" "jenkins_mav_ans_instance" {
  ami = var.jenkins-prod-ami
  instance_type = var.instance_type
  key_name = var.key_pair
  user_data = "${file("./installations/jenkins-install.sh")}"
  security_groups = [ "${aws_security_group.jenkins-instance-sg.id}" ]
  subnet_id = aws_subnet.Public_ALB_NAT_1_Sub.id

  tags = {
    "Name" = "Jenkins-Maven-Ansible"
  }
}

resource "aws_instance" "sonarqube_instance" {
  ami = var.sonar-ami
  instance_type = var.instance_type
  key_name = var.key_pair
  user_data = "${file("./installations/sonarqube-install.sh")}"
  security_groups = [ "${aws_security_group.sonar-instance-sg.id}" ]
  subnet_id = aws_subnet.Public_ALB_NAT_1_Sub.id

  tags = {
    "Name" = "SoanrQube"
  }
}


resource "aws_instance" "prometheus" {
   ami = var.prometheus-grafana-ami
  instance_type = var.instance_type
  key_name = var.key_pair
  user_data = "${file("./installations/prometheus.sh")}"
  security_groups = [ "${aws_security_group.prometheus-instance-sg.id}" ]
  subnet_id = aws_subnet.Public_ALB_NAT_1_Sub.id

  tags = {
    "Name" = "Prometheus"
  }
}

resource "aws_instance" "grafana-instance-sg" {
  ami = var.prometheus-grafana-ami
  instance_type = var.instance_type
  key_name = var.key_pair
  user_data = "${file("./installations/grafana.sh")}"
  security_groups = [ "${aws_security_group.grafana-instance-sg.id}" ]
  subnet_id = aws_subnet.Public_ALB_NAT_1_Sub.id

  tags = {
    "Name" = "Grafana"
  }
}

resource "aws_instance" "Prod-instance-sg" {
  ami = var.jenkins-prod-ami
  instance_type = var.instance_type
  key_name = var.key_pair
  user_data = "${file("./installations/node-exporter.sh")}"
  security_groups = [ "${aws_security_group.prod-instance-sg.id}" ]
  subnet_id = aws_subnet.Private_Web_1_Sub.id

  tags = {
    "Name" = "Prod"
  }
}

