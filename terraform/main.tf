terraform {
  backend "s3" {
    bucket     = "terraform-state-storage-586877430255"
    lock_table = "terraform-state-lock-586877430255"
    key        = "docs-av-byu-edu.tfstate"
    region     = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ssm_parameter" "r53_zone_id" {
  name = "/route53/zone/av-id"
}

resource "aws_route53_record" "gh_pages" {
  name    = "docs.av.byu.edu"
  zone_id = data.aws_ssm_parameter.r53_zone_id.value
  type    = "A"
  ttl     = 3600

  // https://help.github.com/en/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}
