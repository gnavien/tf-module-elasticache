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


resource "aws_elasticache_replication_group" "main" {
  replication_group_id          = "${var.component}-${var.env}"
  replication_group_description = "${var.component}-${var.env}"
  node_type                     = var.node_type # "cache.t2.small"
  port                          = var.port  #6379
  automatic_failover_enabled    = true
  # When you have a cluster in a 3 node, only one will be primary and the rest will be secondary nodes. Only 1 node will be doing the write operation and the rest will be doing read operation.

  num_node_groups         = var.num_node_groups #2
  replicas_per_node_group = var.replicas_per_node_group #1
  parameter_group_name    = "default.redis6.x.cluster.on"
  security_group_ids      = [aws_security_group.main.id]
  kms_key_id              = var.kms_key_arn

}


