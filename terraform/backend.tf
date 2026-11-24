
terraform {
  backend "s3" {
    bucket       = "student-management-tfstate-c3ebd8bb"
    key          = "student-management/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
