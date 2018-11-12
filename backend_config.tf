terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-246505230303"
    key            = "aws_iam_multiaccount.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
  }
}
