resource "aws_dynamodb_table" "terraform_locks" {
  name         = "bloomreach-dev-interviews-terraform-ayaelawdan-tflocks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags         = merge({ Name = "bloomreach-dev-interviews-terraform-ayaelawdan-tflocks" }, local.dev-tags)
  attribute {
    name = "LockID"
    type = "S"
  }
}