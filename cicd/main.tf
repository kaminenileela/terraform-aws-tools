module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-tf"
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-015c3232180617394"]
  subnet_id              = "subnet-0f4f0cef3b00114cb"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins.sh")
  tags = {
    Name = "jenkins-tf"
  }
}

module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-015c3232180617394"]
  subnet_id = "subnet-0f4f0cef3b00114cb"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins-agent.sh")
  tags = {
    Name = "jenkins-agent"
  }
}

module "docker" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "docker"

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-015c3232180617394"]
  subnet_id = "subnet-0f4f0cef3b00114cb"
  ami = data.aws_ami.ami_info.id
  user_data = file("docker.sh")
  tags = {
    Name = "docker"
  }
}

# resource "aws_key_pair" "tools" {
#   key_name   = "tools"
#   # public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+fcmTgj3LtZ9uRhv70aoWwgZ1X2zb2vxkworAMKKaQ Leela@LEELA-DESKTOP"
#   public_key = file ("~/.ssh/tools.pub")
# }

# module "nexus" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   name = "nexus"
#   key_name = aws_key_pair.tools.key_name
#   instance_type          = "t3.medium"
#   vpc_security_group_ids = ["sg-08f2ddc93f0e03f9f"]
#   subnet_id = "subnet-0db0c24c719dbb867"
#   ami = data.aws_ami.nexus_ami_info.id
#   root_block_device = [
#     {
#       volume_type = "gp3"
#       volume_size = 30
#     }
#   ]
#   tags = {
#     Name = "nexus"
#   }
# }

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
      ]
      allow_overwrite = true
    }
    # {
    #   name    = "nexus"
    #   type    = "A"
    #   ttl     = 1
    #   records = [
    #     module.nexus.private_ip
    #   ]
    #   allow_overwrite = true
    # }
  ]

}