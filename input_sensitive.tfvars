tenant_id   = "72f988bf-86f1-41af-91ab-2d7cd011db47"
prefix      = "datamz"
environment = "dev"
location    = "southcentralus"

vnet_address_space            = "10.0.0.0/21" // This should probably not be a huge address block
firewall_subnet_address_space = "10.0.0.0/24"
services_subnet_address_space = "10.0.1.0/24"
gateway_subnet_address_space  = "10.0.2.0/24"
vpn_client_address_space      = "192.168.44.0/22"
firewall_private_ip           = "10.0.0.4" // This will be the first IP from the firewall_subnet_address_space range assigned above

tags = {
  deployedBy = "thosch"
  Owner      = ""
  Project    = "Data Management Zone"
  Toolkit    = "Terraform"
}

privatelink-dns-zone-names = [
  "privatelink.database.windows.net",
  "privatelink.sql.azuresynapse.net",
  "privatelink.dev.azuresynapse.net",
  "privatelink.azuresynapse.net",
  "privatelink.blob.core.windows.net",
  "privatelink.table.core.windows.net",
  "privatelink.queue.core.windows.net",
  "privatelink.file.core.windows.net",
  "privatelink.web.core.windows.net",
  "privatelink.dfs.core.windows.net",
  "privatelink.documents.azure.com",
  "privatelink.postgres.database.azure.com",
  "privatelink.mysql.database.azure.com",
  "privatelink.mariadb.database.azure.com",
  "privatelink.vaultcore.azure.net",
  "privatelink.azurecr.io",
  "privatelink.azconfig.io",
  "privatelink.servicebus.windows.net",
  "privatelink.eventgrid.azure.net",
  "privatelink.azurewebsites.net",
  "privatelink.api.azureml.ms",
  "privatelink.notebooks.azure.net",
  "privatelink.monitor.azure.com",
  "privatelink.datafactory.azure.net",
  "privatelink.adf.azure.com",
  "privatelink.purview.azure.com",
  "privatelink.purviewstudio.azure.com"
]

vnet_gateway_public_cert = <<EOF
MIIC5zCCAc+gAwIBAgIQFl1joPZqbJ5OIf53Fsbr9DANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0yMTExMDEyMDM4NTNaFw0yMjExMDEy
MDU4NTNaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAnAj+nhfl1BAmoOsfqpmHztESMruQPhpzFerlUPu3CEWm
hr7CN7SLmJovhmIXXMrrLo1fDg7sIEqCgmFWPVQIWH2evA3pmV0wUNp2VOxD7I6z
uOcmwhIDEXnKAzRdZHolTmnChQUY9VRLSaiX2J1eND//NDMR4k5ptG1vSMJhl8Y6
4JECZu4hnioTDDbpk+KGijutYEpUip4/zBP+kUiwb6eMNecoaT0Ads7l+O9GgGrP
F6PtyFECxnvxkiW61icqktm6AZqluJE30XDv6qJhCLhxT1LnNIMSdQmlB+NMcSHf
HAWQUxQTyMeiDh4PgL3KxwA+vN5oKkWKGazADh8ABQIDAQABozEwLzAOBgNVHQ8B
Af8EBAMCAgQwHQYDVR0OBBYEFJmwl9l5Bg0Sn+R4ei6AjOf2Qq1SMA0GCSqGSIb3
DQEBCwUAA4IBAQCJdJ2uR0UFfb5BdsSZ9tACz/uGgNhEs5AAfeFpjfYhqXrV9ZT9
fFCjd4s6HfGv4eDGRtbXWxtZRYmFm0tF88uJJ6Bil+iqZSKf4O18mvqscu5dL+i3
pc7jMMMvloZ8ri2KP31eJ1dmd8NgIacUkAMJp0asjdVLOPHq7p7gP/qU9hLwlaca
fC34KLbO6iRkiYYISdsLMnpIQkXTqjnigzzRBPDEoYXfU6wpZhMVkCK2CGY2wbfO
iAiKOYjjeXQNpxmitliyF/qQ/kMf6d82+Pn/xtmN9xjUaRYTNKqSdR8xqHABoQXo
ttsNFkaBAfWDsqnOyHvVW8k0oBMyXOveMj/m
EOF
