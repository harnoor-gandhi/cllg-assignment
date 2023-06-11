terraform {
  backend "s3" {
    bucket         = "harnoor-bucket-2" 
    key            = "terraform.tfstate"
    region         = "us-east-1"  
  }
}
