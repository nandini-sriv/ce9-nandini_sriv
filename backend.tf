terraform {
  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "nandini-ce9-module2-lesson4.tfstate" # Replace the value of key to <your suggested name>.tfstat   
    region = "us-east-1"
  }
}