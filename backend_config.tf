terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-dc5b6b998a6598b163d0e6e5e8dc9d4bc5da0113"
    key            = "aws_iam_multiaccount.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }
}
