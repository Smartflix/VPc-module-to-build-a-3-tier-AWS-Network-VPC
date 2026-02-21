# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "my-smartflix-bucket4"
    key       = "jupital-website-ecs"
    region    = "us-east-1"
    profile   = "terraform-user"
  }
}