output "ec2-public_ip"{
    value = aws_instance.aws_ec2.public_ip
}