

data "aws_security_group" "my_scgrp" {
    id = "sg-01056947cc9261a78"
}


data "aws_subnet" "my_subs" {
    id = "subnet-08e87f2aa43b54abf"
}

data "aws_iam_role" "my_new"{
    name = "rodney-fresh-for-terraform"
}

