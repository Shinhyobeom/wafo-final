resource "aws_elasticache_subnet_group" "wafo_redis_subnet" {
    name       = "${var.name}-redis-subnet"
    subnet_ids = [aws_subnet.wafo_redis.id]
}

resource "aws_elasticache_cluster" "wafo_redis" {
    cluster_id           = "${var.name}-redis"
    engine               = var.redis_engine
    node_type            = var.redis_node_type
    num_cache_nodes      = 1                # 1이상
    subnet_group_name    = aws_elasticache_subnet_group.wafo_redis_subnet.name
    security_group_ids   = [aws_security_group.sg_redis.id]
    #parameter_group_name = "default.redis6.x.cluster.on"
    #engine_version       = "6.2.5"
    port                 = var.port_redis
}