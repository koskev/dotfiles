terraform {
  required_version = ">= 1.10.0"
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "~> 1.0"
    }
        github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "sops" {}
provider "github" {}

variable "repositories" {
  description = "GitHub repository names"
  type        = list(string)
  default = [ 
    "machtnix",
    "rufaco",
    "vrl-ls",
    "difftastic",
    "grustonnet-ls",
    "pushtotalk",
    "swayautonames",
    "hms-mqtt-publisher",
  ]
}

data "sops_file" "cachix" {
  source_file = "cachix.yaml"
}

resource "github_actions_secret" "cachix_auth_token" {
  for_each = toset(var.repositories)
  repository       = each.value
  plaintext_value      = data.sops_file.cachix.data["CACHIX_AUTH_TOKEN"]
  secret_name = "CACHIX_AUTH_TOKEN"
}


resource "github_actions_secret" "cachix_signing_key" {
  for_each = toset(var.repositories)
  repository       = each.value
  plaintext_value      = data.sops_file.cachix.data["CACHIX_SIGNING_KEY"]
  secret_name = "CACHIX_SIGNING_KEY"
}
