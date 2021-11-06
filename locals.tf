locals {
  name                       = lower("${var.prefix}-${var.environment}")
  network-resource-group     = "rg-${local.name}-network"
  automation-resource-group  = "rg-${local.name}-automation"
  management-resource-group  = "rg-${local.name}-management"
  dns-zone-resource-group    = "rg-${local.name}-private-dns"
  governance-resource-group  = "rg-${local.name}-governance"
  containers-resource-group  = "rg-${local.name}-containers"
  consumption-resource-group = "rg-${local.name}-consumption"
  monitoring-resource-group  = "rg-${local.name}-monitoring"
}
