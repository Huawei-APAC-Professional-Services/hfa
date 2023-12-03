data "terraform_remote_state" "hfa_iam" {
  backend = "local"

  config = {
    path = "${path.module}/../HFA-IAM/terraform.tfstate"
  }
}

data "terraform_remote_state" "hfa_network" {
  backend = "local"

  config = {
    path = "${path.module}/../HFA-Network/terraform.tfstate"
  }
}

