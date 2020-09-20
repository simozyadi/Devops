output "client_key" {
  value = "${module.kubernetes.client_key}"
}

output "client_certificate" {
  value = "${module.kubernetes.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${module.kubernetes.cluster_ca_certificate}"
}

output "host" {
  value = "${module.kubernetes.host}"
}

output "cluster_username" {
    value = "${module.kubernetes.cluster_username}"
}

output "cluster_password" {
    value = "${module.kubernetes.cluster_password}"
}

output "kube_config" {
    value = "${module.kubernetes.kube_config}"
}
