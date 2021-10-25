#Azure Firewall Setup
#Public IP Prefix
resource "azurerm_public_ip_prefix" "firewall_public_ip_prefix" {
  name                = "${var.environment}-fw-pip-prefix"
  location            = var.location
  resource_group_name = var.rg_name

  prefix_length = 30

  tags = {
    Environment = var.environment
  }
}

#Public IP
resource "azurerm_public_ip" "firewall-public_ip" {
  name                = "${var.environment}-fw-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  domain_name_label   = "${var.environment}-fw-pip"
  public_ip_prefix_id = azurerm_public_ip_prefix.firewall_public_ip_prefix.id

  tags = {
    Environment = var.environment
    Function    = "data-management-zone-azurefirewall"
  }

  depends_on = [
    azurerm_public_ip_prefix.firewall_public_ip_prefix
  ]
}

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "${var.environment}-firewall-policy"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Premium"
  intrusion_detection {
    mode = "Deny"
  }
  threat_intelligence_mode = "Deny"
  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_network_rules_collection" {
  name               = "${var.environment}-fw-pol-networkrules-collection"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 10000

  network_rule_collection {
    name     = "MachineLearning-NetworkRules"
    priority = 10100
    action   = "Allow"
    rule {
      name                  = "MachineLearning-NetworkRule-001"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureActiveDirectory", "AzureMachineLearning", "AzureResourceManager", "Storage", "AzureKeyVault", "AzureContainerRegistry", "MicrosoftContainerRegistry", "AzureFrontDoor.FirstParty"]
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "HDInsight-NetworkRules"
    priority = 10200
    action   = "Allow"
    rule {
      name                  = "HDInsight-NetworkRule-001"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["Sql"]
      destination_ports     = ["1433"]
    }
    rule {
      name                  = "HDInsight-NetworkRule-002"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureMonitor"]
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "Databricks-NetworkRules"
    priority = 10300
    action   = "Allow"
    rule {
      name                  = "Databricks-NetworkRule-001"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureActiveDirectory", "AzureFrontDoor.Frontend"]
      destination_ports     = ["443"]
    }
    rule {
      name                  = "Databricks-NetworkRule-002"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureDatabricks", "Storage"]
      destination_ports     = ["443"]
    }
    rule {
      name                  = "Databricks-NetworkRule-003"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["Sql"]
      destination_ports     = ["3306"]
    }
    rule {
      name                  = "Databricks-NetworkRule-004"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["EventHub"]
      destination_ports     = ["9093"]
    }
  }

  network_rule_collection {
    name     = "Azure-NetworkRules"
    priority = 10400
    action   = "Allow"
    rule {
      name                  = "Azure-NetworkRule-001"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["23.102.135.246", "51.4.143.248", "23.97.0.13", "42.159.7.249"]
      destination_ports     = ["1688"]
    }
    rule {
      name                  = "HDInsight-NetworkRule-002"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureMonitor"]
      destination_ports     = ["*"]
    }
  }

  depends_on = [
    azurerm_firewall_policy.firewall_policy
  ]

}

resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_application_rules_collection" {
  name               = "${var.environment}-fw-pol-applicationrules-collection"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 20000

  application_rule_collection {
    name     = "MachineLearning-ApplicationRules"
    priority = 20100
    action   = "Allow"
    rule {
      name = "MachineLearning-ApplicationRule-001"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["anaconda.com", "*.anaconda.com", "*.anaconda.org", "pypi.org", "cloud.r-project.org", "*pytorch.org", "*.tensorflow.org", "*.instances.azureml.net", "*.instances.azureml.ms"]
      terminate_tls     = false
    }
  }

  application_rule_collection {
    name     = "HDInsight-ApplicationRules"
    priority = 20200
    action   = "Allow"
    rule {
      name = "HDInsight-ApplicationRule-001"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdn_tags = [
        "HDInsight",
        "WindowsUpdate"
      ]
      terminate_tls = false
    }
    rule {
      name = "HDInsight-ApplicationRule-002"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "login.microsoftonline.com",
        "login.windows.net"
      ]
      terminate_tls = false
    }
  }

  application_rule_collection {
    name     = "DataFactory-ApplicationRules"
    priority = 20300
    action   = "Allow"
    rule {
      name = "DataFactory-ApplicationRule-001"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "go.microsoft.com",
        "download.microsoft.com",
        "browser.events.data.msn.com",
        "*.clouddatahub.net"
      ]
      terminate_tls = false
    }
    rule {
      name = "DataFactory-ApplicationRule-002"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "*.servicebus.windows.net"
      ]
      terminate_tls = false
    }
    rule {
      name = "DataFactory-ApplicationRule-003"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "*.githubusercontent.com"
      ]
      terminate_tls = false
    }
  }

  application_rule_collection {
    name     = "Databricks-ApplicationRules"
    priority = 20400
    action   = "Allow"
    rule {
      name = "Databricks-ApplicationRule-001"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "tunnel.australiaeast.azuredatabricks.net",
        "tunnel.brazilsouth.azuredatabricks.net",
        "tunnel.canadacentral.azuredatabricks.net",
        "tunnel.centralindia.azuredatabricks.net",
        "tunnel.eastus2.azuredatabricks.net",
        "tunnel.eastus2c2.azuredatabricks.net",
        "tunnel.eastusc3.azuredatabricks.net",
        "tunnel.centralusc2.azuredatabricks.net",
        "tunnel.northcentralusc2.azuredatabricks.net",
        "tunnel.southeastasia.azuredatabricks.net",
        "tunnel.francecentral.azuredatabricks.net",
        "tunnel.japaneast.azuredatabricks.net",
        "tunnel.koreacentral.azuredatabricks.net",
        "tunnel.northeuropec2.azuredatabricks.net",
        "tunnel.westus.azuredatabricks.net",
        "tunnel.westeurope.azuredatabricks.net",
        "tunnel.westeuropec2.azuredatabricks.net",
        "tunnel.southafricanorth.azuredatabricks.net",
        "tunnel.switzerlandnorth.azuredatabricks.net",
        "tunnel.uaenorth.azuredatabricks.net",
        "tunnel.ukwest.azuredatabricks.net"
      ]
      terminate_tls = false
    }
    rule {
      name = "Databricks-ApplicationRule-002"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "archive.ubuntu.com",
        "github.com",
        "*.maven.apache.org",
        "conjars.org"
      ]
      terminate_tls = false
    }
  }

  application_rule_collection {
    name     = "Azure-ApplicationRules"
    priority = 20500
    action   = "Allow"
    rule {
      name = "Azure-ApplicationRule-001"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "*microsoft.com",
        "*azure.com",
        "*windows.com",
        "*windows.net",
        "*azure-automation.net",
        "*digicert.com"
      ]
      terminate_tls = false
    }
    rule {
      name = "Databricks-ApplicationRule-002"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["*"]
      destination_fqdns = [
        "archive.ubuntu.com",
        "github.com",
        "*.maven.apache.org",
        "conjars.org"
      ]
      terminate_tls = false
    }
  }
  depends_on = [
    azurerm_firewall_policy.firewall_policy,
    azurerm_firewall_policy_rule_collection_group.firewall_policy_network_rules_collection
  ]
}

#Azure Firewall Instance
resource "azurerm_firewall" "firewall" {
  name                = "${var.environment}-firewall"
  location            = var.location
  resource_group_name = var.rg_name
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.fw_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall-public_ip.id
  }
  depends_on = [
    azurerm_firewall_policy.firewall_policy
  ]
}
