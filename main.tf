provider "aws" {
  region = var.region
}

resource "aws_vpc" "ahmad-vpc-terra" {
  cidr_block = var.vpc-cidr
  tags = {
    "Name" = "ahmad-vpc-terra"
    "owner" = "ahmad"
  }
}

resource "aws_internet_gateway" "ahmad-igw-terra" {  
    vpc_id = aws_vpc.ahmad-vpc-terra.id
    tags = {
        "Name" = "ahmad-igw-terra"
        "owner" = var.owner
    }
}

resource "aws_subnet" "ahmad-public-subnet-terra" {
  vpc_id = aws_vpc.ahmad-vpc-terra.id
  cidr_block = var.subnet-cidr
  tags = {
    "Name" = "ahmad-public-subnet-terra"
    "owner" = var.owner
  }
}

resource "aws_route_table" "ahmad-public-sub-rt-terra" {
  vpc_id = aws_vpc.ahmad-vpc-terra.id
  route {
    cidr_block = var.all-traffic-cidr
    gateway_id = aws_internet_gateway.ahmad-igw-terra.id
  }
  tags = {
    "Name" = "ahmad-public-sub-rt-terra"
    "owner" = var.owner
  }
}

resource "aws_route_table_association" "ahmad-subnet-association" {
  subnet_id = aws_subnet.ahmad-public-subnet-terra.id
  route_table_id = aws_route_table.ahmad-public-sub-rt-terra.id
}

resource "aws_security_group" "ahmad-sg-terra" {
  name = "Http and SSH"
  vpc_id = aws_vpc.ahmad-vpc-terra.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.all-traffic-cidr]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.all-traffic-cidr]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.all-traffic-cidr]
  }  

  tags = {
    "Name" = "ahmad-sg-terra"
    "owner" = var.owner
  }
}

##################    ECS Resources    ##########################
resource "aws_ecs_cluster" "ahmad-ecs-cluster-terra" {
  name = "ahmad-ecs-cluster-terra"
  tags = {
    "Name" = "ahmad-ecs-cluster-terra"
    "owner" = "ahmad"
  }
}

resource "aws_ecs_task_definition" "ahmad-taskdef-terra" {
  family = "ahmad-taskdef-terra"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 1024
  memory = 2048
  
  execution_role_arn = "arn:aws:iam::504649076991:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
        name = "nginx-terra"
        image = "504649076991.dkr.ecr.us-east-2.amazonaws.com/ahmad-repo-terra:v1"
        cpu = 1024
        memory = 2048
        essential = true
        portMappings = [
            {
                containerPort = 80
                hostPort = 80
            }
        ]
    }
  ])

  depends_on = [ aws_ecr_repository.ahmad-repo-terra, null_resource.ecr-docker-push-ahmad ]
  tags = {
    "Name" = "ahmad-taskdef-terra"
    "owner" = "ahmad"
  }
}

resource "aws_ecs_service" "ahmad-service-terra" {
  name = "ahmad-service-terra"
  launch_type = "FARGATE"
  cluster = aws_ecs_cluster.ahmad-ecs-cluster-terra.id
  task_definition = aws_ecs_task_definition.ahmad-taskdef-terra.arn
  desired_count = 1
  
  network_configuration {
    subnets = [aws_subnet.ahmad-public-subnet-terra.id]
    security_groups = [aws_security_group.ahmad-sg-terra.id]
    assign_public_ip = true
  }

  tags = {
    "Name" = "ahmad-service-terra"
    "owner" = "ahmad"
  }
}

resource "aws_ecr_repository" "ahmad-repo-terra" {
  name = "ahmad-repo-terra"
  image_tag_mutability = "MUTABLE"
}

resource "null_resource" "ecr-docker-push-ahmad" {
  depends_on = [ aws_ecr_repository.ahmad-repo-terra ]
  provisioner "local-exec" {
    command = <<EOF
      docker pull nginx:latest
      aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 504649076991.dkr.ecr.us-east-2.amazonaws.com
      docker tag nginx:latest 504649076991.dkr.ecr.us-east-2.amazonaws.com/ahmad-repo-terra:v1
      docker push 504649076991.dkr.ecr.us-east-2.amazonaws.com/ahmad-repo-terra:v1
    EOF
  }

}












