
resource "azurerm_policy_set_definition" "enterprise_scale" {
  for_each = local.azurerm_policy_set_definition_enterprise_scale

  # Mandatory resource attributes
  name         = each.value.template.name
  policy_type  = "Custom"
  display_name = each.value.template.properties.displayName

  # Dynamic configuration blocks
  dynamic "policy_definition_reference" {
    for_each = [
      for item in each.value.template.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
      }
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = policy_definition_reference.value["parameters"]
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
    }
  }

  # Optional resource attributes
  description = try(each.value.template.properties.description, "${each.value.template.properties.displayName} Policy Set Definition at scope ${each.value.scope_id}")
  #management_group_name = try(basename(each.value.scope_id), null)
  metadata   = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : null
  parameters = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : null

  # Set explicit dependency on Management Group and Policy Definition deployments
  depends_on = [
    azurerm_policy_definition.enterprise_scale
  ]
}
