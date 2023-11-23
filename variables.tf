variable "rodney_aws_provider_region" {
  type = string
  default = "us-west-2"
}

variable "key_pair_ssh"{
    type = string
    default = "rod-Toxic-Task-jenk-gitlab"
}

variable "user_tags"{
    type = object({
        Owner = string
        bootcamp = string
        expiration_date = string
    })

    default = {
        Owner = "rodney_aws_hash_ted_search"
        bootcamp = "ghana1"
        expiration_date = "2023-09-09"

    }
}



variable "assoc_public_ip_ids"{
    type = bool

    default = true
}


variable "aws_instances"{
    type = list(object({
            ami  = string
            instance_type = string
            Name = string
        })
    )

    default = [
      {
          ami    = "ami-0ecc74eca1d66d8a6"
          instance_type = "t2.micro"
          Name = "rodney-instance-1"
      },
      {
          ami    = "ami-0ecc74eca1d66d8a6"
          instance_type = "t2.micro"
          Name = "rodney-instance-2"
      }
    ]
}
