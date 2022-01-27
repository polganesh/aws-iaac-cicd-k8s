resource "aws_codecommit_repository" "repo" {
  repository_name = "springk8s"
  description     = "This code commit git repo mirrored with on premises bitbucket/github/gitlab repo"
  lifecycle {
    prevent_destroy = true
  }
}

output "clone_url_http" {
  value = aws_codecommit_repository.repo.clone_url_http
}


output "clone_url_ssh" {
  value = aws_codecommit_repository.repo.clone_url_ssh
}

output "arn" {
  value = aws_codecommit_repository.repo.arn
}

output "repository_id" {
  value = aws_codecommit_repository.repo.repository_id
}


