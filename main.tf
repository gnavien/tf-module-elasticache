resource "aws_elasticache_subnet_group" "main" {
name       = "${var.component}-${var.env}"
subnet_ids = var.subnet_ids

tags       = merge({ Name = "${var.component}-${var.env}" }, var.tags)
}

resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.sg_subnet_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}
# Here we are going with redis database for elasticache



resource "aws_elasticache_cluster" "instance" {
  cluster_id           = "${var.component}-${var.env}-instance"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = var.engine_version
  port                 = 6379
  security_group_ids   = [aws_security_group.main.id]
  subnet_group_name    = aws_elasticache_subnet_group.main.name
}

