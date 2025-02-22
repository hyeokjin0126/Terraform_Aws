# aws configure --profile Setting
provider "aws" {
  region = "<region>"
  profile = "<Profile>"
}

# aws access key
provider "aws" {
  access_key = "<Access_Key>"
  secret_key = "<Secret_Key>"
  region = "<region>"
}