/*
output "dns-zones" {
  value = module.dmz-private-dns-zones.priv-dns-zones
}


output "test-out" {
  value = module.dmz-private-dns-zones.test-out
}

*/
output "purview-output" {
  value = module.dmz-purview.purview-output
}

output "purview-2" {
  value = module.dmz-purview.purview-identity[0].principal_id
}
