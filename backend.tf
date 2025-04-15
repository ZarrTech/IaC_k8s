terraform {
  backend "remote" {
    organization = "zarrAI"
    workspaces {
      name = "kube_cicd"
    }

  }
}