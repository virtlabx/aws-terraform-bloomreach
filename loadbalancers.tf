resource "aws_lb" "jenkins-vault-lb" {
  name               = "lb-jenkins-vault"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bloomreach-jenkins-dev-sg.id]
  subnets            = module.eks-vpc.public_subnets
  tags               = merge({ Name = "lb-jenkins-vault" }, local.dev-tags)
}

resource "aws_lb_listener" "https_jenkins" {
  load_balancer_arn = aws_lb.jenkins-vault-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.jenkins_vault_bloomreach_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-jenkins-tg.arn
  }
}

resource "aws_lb_target_group" "lb-jenkins-tg" {
  name     = "lb-jenkins-tg"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = module.eks-vpc.vpc_id
  tags     = merge({ Name = "lb-jenkins-tg" }, local.dev-tags)
  health_check {
    protocol            = "HTTP"
    path                = "/login"
    port                = "8080"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "lb-jenkins-tg-attachment" {
  target_group_arn = aws_lb_target_group.lb-jenkins-tg.arn
  target_id        = flatten(module.jenkins-dev-master.instance_id)[0]
  port             = "8080"
}

resource "aws_lb_listener" "https_vault" {
  load_balancer_arn = aws_lb.jenkins-vault-lb.arn
  port              = "8200"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.jenkins_vault_bloomreach_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-vault-tg.arn
  }
}

resource "aws_lb_target_group" "lb-vault-tg" {
  name     = "lb-vault-tg"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = module.eks-vpc.vpc_id
  tags     = merge({ Name = "lb-vault-tg" }, local.dev-tags)
  health_check {
    protocol            = "HTTP"
    path                = "/ui"
    port                = "8200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "307"
  }
}

resource "aws_lb_target_group_attachment" "lb-vault-tg-attachment" {
  target_group_arn = aws_lb_target_group.lb-vault-tg.arn
  target_id        = flatten(module.jenkins-dev-master.instance_id)[0]
  port             = "8200"
}