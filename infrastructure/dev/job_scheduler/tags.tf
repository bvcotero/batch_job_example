###############################################################
#             MODULE TO CREATE TAGS FOR RESOURCES             #
###############################################################


module "tags" {
  source = "git::git@github.com:ThomsonReuters-IPS/terraform-modules.git//tagging/merge-tags?ref=v0.7.25"

  add_tags = "${var.default_tags}"
}
