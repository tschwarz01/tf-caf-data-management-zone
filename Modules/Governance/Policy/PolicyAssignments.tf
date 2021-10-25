
/*
resource "azurerm_role_assignment" "Diag_Activity_Log_Role_Assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_subscription_policy_assignment.Assign_Diag_Activity_Log.identity[0].principal_id
  depends_on = [
    azurerm_subscription_policy_assignment.Assign_Diag_Activity_Log
  ]
}
*/
