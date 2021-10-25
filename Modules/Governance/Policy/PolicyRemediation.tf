/*
resource "azurerm_policy_remediation" "Diag_Activity_Log_Remediation" {
  name                    = "diag-activity-log-remediation"
  scope                   = data.azurerm_subscription.current.id
  policy_assignment_id    = azurerm_subscription_policy_assignment.Assign_Diag_Activity_Log.id
  resource_discovery_mode = "ReEvaluateCompliance"
  depends_on = [
    azurerm_role_assignment.Diag_Activity_Log_Role_Assignment
  ]
}
*/
