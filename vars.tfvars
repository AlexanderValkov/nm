region         = "us-east-1"
vpc_cidr_block = "10.0.0.0/16"

subnet = {
  public = {
    a = {
      cidr_block = "10.0.0.0/24"
      az_postfix = "a"
    }
    b = {
      cidr_block = "10.0.1.0/24"
      az_postfix = "b"
    }
  }
  private = {
    a = {
      cidr_block = "10.0.2.0/24"
      az_postfix = "a"
    }
    b = {
      cidr_block = "10.0.3.0/24"
      az_postfix = "b"
    }
  }
}
