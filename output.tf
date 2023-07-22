## Output All IPs
data "aws_network_interfaces" "all" {
  tags = {
    "aws:ecs:clusterName" = "pohleng-ecs-tf" # replace with desired label key-value
  }
}

output "all_eni_id" {
  value = data.aws_network_interfaces.all.ids
}

data "aws_network_interface" "all" {
  for_each = toset(data.aws_network_interfaces.all.ids)
  id       = each.key
}

output "all_public_ip" {
  value = {
    for k, v in data.aws_network_interface.all : k => v.association[0].public_ip
  }
}