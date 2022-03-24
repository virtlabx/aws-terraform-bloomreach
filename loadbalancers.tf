resource "aws_lb" "jenkins-vault-lb" {
  name               = "lb-jenkins-vault"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bloomreach-jenkins-dev-sg.id]
  subnets            = module.eks-vpc.public_subnets
  tags               = merge({ Name = "lb-jenkins-vault" }, local.dev-tags)
}

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.jenkins-vault-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.jenkins_vault_bloomreach_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-jenkins-vault-tg.arn
  }
}

resource "aws_lb_listener_rule" "https-listener-rule" {
  listener_arn = aws_lb_listener.HTTPS.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-jenkins-vault-tg.arn
  }
  condition {
    host_header {
      values = ["jenkins-vault-bloomreach.com"]
    }
  }
}

resource "aws_lb_target_group" "lb-jenkins-vault-tg" {
  name     = "lb-jenkins-vault-tg"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = module.eks-vpc.vpc_id
  tags     = merge({ Name = "lb-jenkins-vault-tg" }, local.dev-tags)
  health_check {
    path = "/login"
    port = "8080"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 60
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "lb-jenkins-vault-tg-attachment" {
  target_group_arn = aws_lb_target_group.lb-jenkins-vault-tg.arn
  target_id        = module.jenkins-dev-master[0].id
  port             = "8080"
}