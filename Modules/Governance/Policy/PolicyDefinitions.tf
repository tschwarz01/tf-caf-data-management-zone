
resource "azurerm_policy_definition" "enterprise_scale" {
  for_each = local.azurerm_policy_definition_enterprise_scale

  # Mandatory resource attributes
  name         = each.value.template.name
  policy_type  = "Custom"
  mode         = each.value.template.properties.mode
  display_name = each.value.template.properties.displayName

  # Optional resource attributes
  description = try(length(each.value.template.properties.description) > 0, false) ? each.value.template.properties.description : "${each.value.template.properties.displayName} Policy Definition at scope ${each.value.scope_id}"
  policy_rule = try(length(each.value.template.properties.policyRule) > 0, false) ? jsonencode(each.value.template.properties.policyRule) : local.empty_string
  metadata    = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : local.empty_string
  parameters  = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : local.empty_string
}




/*
resource "azurerm_policy_definition" "Diag_Activity_Log" {
  name         = "Deploy-Diagnostics-ActivityLog"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Diagnostic Settings for Activity Log to Log Analytics workspace"

  metadata = <<METADATA
    {
    "category": "Monitoring"
    }
METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions"
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Insights/diagnosticSettings",
          "deploymentScope": "Subscription",
          "existenceScope": "Subscription",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                "equals": "true"
              },
              {
                "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                "equals": "[parameters('logAnalytics')]"
              }
            ]
          },
          "deployment": {
            "location": "southcentralus",
            "properties": {
              "mode": "Incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "logAnalytics": {
                    "type": "String"
                  },
                  "logsEnabled": {
                    "type": "String"
                  }
                },
                "variables": {},
                "resources": [
                  {
                    "name": "subscriptionToLa",
                    "type": "Microsoft.Insights/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "location": "Global",
                    "properties": {
                      "workspaceId": "[parameters('logAnalytics')]",
                      "logs": [
                        {
                          "category": "Administrative",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "Security",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "ServiceHealth",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "Alert",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "Recommendation",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "Policy",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "Autoscale",
                          "enabled": "[parameters('logsEnabled')]"
                        },
                        {
                          "category": "ResourceHealth",
                          "enabled": "[parameters('logsEnabled')]"
                        }
                      ]
                    }
                  }
                ],
                "outputs": {}
              },
              "parameters": {
                "logAnalytics": {
                  "value": "[parameters('logAnalytics')]"
                },
                "logsEnabled": {
                  "value": "[parameters('logsEnabled')]"
                }
              }
            }
          },
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ]
        }
      }
    }
POLICY_RULE

  parameters = <<PARAMETERS
    {
      "logAnalytics": {
        "type": "String",
        "metadata": {
          "displayName": "Primary Log Analytics workspace",
          "description": "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID.",
          "strongType": "omsWorkspace"
        }
      },
      "effect": {
        "type": "String",
        "defaultValue": "DeployIfNotExists",
        "allowedValues": [
          "DeployIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        }
      },
      "logsEnabled": {
        "type": "String",
        "defaultValue": "True",
        "allowedValues": [
          "True",
          "False"
        ],
        "metadata": {
          "displayName": "Enable logs",
          "description": "Whether to enable logs stream to the Log Analytics workspace - True or False"
        }
      }
    }
PARAMETERS
}


locals {
  log_analytics_workspace_id = <<PARAMETERS
{
  "logAnalytics": {
    "value": "${var.log-analytics-workspace-id}"
  }
}
PARAMETERS
}

resource "azurerm_policy_definition" "enterprise_scale" {
  for_each = local.azurerm_policy_definition_enterprise_scale

  # Mandatory resource attributes
  name         = each.value.template.name
  policy_type  = "Custom"
  mode         = each.value.template.properties.mode
  display_name = each.value.template.properties.displayName

  # Optional resource attributes
  description = try(length(each.value.template.properties.description) > 0, false) ? each.value.template.properties.description : "${each.value.template.properties.displayName} Policy Definition at scope ${each.value.scope_id}"
  policy_rule = try(length(each.value.template.properties.policyRule) > 0, false) ? jsonencode(each.value.template.properties.policyRule) : local.empty_string
  metadata    = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : local.empty_string
  parameters  = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : local.empty_string

}
*/

/*
resource "azurerm_subscription_policy_assignment" "Assign_Diag_Activity_Log" {
  name                 = "Deploy-Diagnostics-ActivityLog"
  policy_definition_id = azurerm_policy_definition.Diag_Activity_Log.id
  subscription_id      = data.azurerm_subscription.current.id
  parameters           = local.log_analytics_workspace_id
  location             = var.location
  identity {
    type = "SystemAssigned"
  }
}
*/


