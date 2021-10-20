data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}


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
  depends_on = [
    azurerm_log_analytics_workspace.log_analytics
  ]
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


resource "azurerm_subscription_policy_assignment" "Assign_Diag_Activity_Log" {
  name                 = "Deploy-Diagnostics-ActivityLog"
  policy_definition_id = azurerm_policy_definition.Diag_Activity_Log.id
  subscription_id      = data.azurerm_subscription.current.id
  parameters = local.log_analytics_workspace_id
  location = var.location
  identity {
      type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "Diag_Activity_Log_Role_Assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_subscription_policy_assignment.Assign_Diag_Activity_Log.identity[0].principal_id
  depends_on = [
    azurerm_subscription_policy_assignment.Assign_Diag_Activity_Log
  ]
}

resource "azurerm_policy_remediation" "Diag_Activity_Log_Remediation" {
  name                 = "diag-activity-log-remediation"
  scope                = data.azurerm_subscription.current.id
  policy_assignment_id = azurerm_subscription_policy_assignment.Assign_Diag_Activity_Log.id
  resource_discovery_mode = "ReEvaluateCompliance"
  depends_on = [
    azurerm_role_assignment.Diag_Activity_Log_Role_Assignment
  ]
}
