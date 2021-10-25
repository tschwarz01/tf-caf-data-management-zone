locals {
  scope_id                                = var.scope_id
  empty_string                            = ""
  custom_policy_definitions_from_json     = tolist(fileset(path.module, "./policy_definitions/*.json"))
  custom_policy_set_definitions_from_json = tolist(fileset(path.module, "./policy_initiatives/policy_set_definition_es_deploy_diag_loganalytics.tmpl.json"))
  custom_policy_assignments_from_json     = tolist(fileset(local.custom_library_path, "**/policy_assignment_*.json"))

  # scope_is_management_group = length(regexall("^/providers/Microsoft.Management/managementGroups/.*", local.scope_id)) > 0
  # scope_is_subscription     = length(regexall("^/subscriptions/.*", local.scope_id)) > 0
  resource_types = {
    policy_assignment     = "Microsoft.Authorization/policyAssignments"
    policy_definition     = "Microsoft.Authorization/policyDefinitions"
    policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
    role_assignment       = "Microsoft.Authorization/roleAssignments"
    role_definition       = "Microsoft.Authorization/roleDefinitions"
  }
  provider_path = {
    policy_assignment     = "${local.scope_id}/providers/Microsoft.Authorization/policyAssignments/"
    policy_definition     = "${local.scope_id}/providers/Microsoft.Authorization/policyDefinitions/"
    policy_set_definition = "${local.scope_id}/providers/Microsoft.Authorization/policySetDefinitions/"
    role_assignment       = "${local.scope_id}/providers/Microsoft.Authorization/roleAssignments/"
    role_definition       = "/providers/Microsoft.Authorization/roleDefinitions/"
  }
}

locals {
  custom_policy_definitions_dataset_from_json = try(length(local.custom_policy_definitions_from_json) > 0, false) ? {
    for filepath in local.custom_policy_definitions_from_json :
    filepath => jsondecode(templatefile("${path.module}/${filepath}", var.template_file_vars))
  } : null

  custom_policy_set_definitions_dataset_from_json = try(length(local.custom_policy_set_definitions_from_json) > 0, false) ? {
    for filepath in local.custom_policy_set_definitions_from_json :
    filepath => jsondecode(templatefile("${path.module}/${filepath}", var.template_file_vars))
  } : null

  custom_policy_definitions_map_from_json = try(length(local.custom_policy_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.custom_policy_definitions_dataset_from_json :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null

  custom_policy_set_definitions_map_from_json = try(length(local.custom_policy_set_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.custom_policy_set_definitions_dataset_from_json :
    value.name => value
    if value.type == local.resource_types.policy_set_definition
  } : null

  policy_definitions_map = merge(
    local.custom_policy_definitions_map_from_json
  )

  policy_set_definitions_map = merge(
    local.custom_policy_set_definitions_map_from_json
  )

  policy_names = toset([
    for val in local.custom_policy_definitions_dataset_from_json : val.name
  ])

  policy_set_names = toset([
    for val in local.custom_policy_set_definitions_dataset_from_json : val.name
  ])

  policy_definitions_output = [
    for policy in local.policy_names :
    {
      resource_id = "${local.provider_path.policy_definition}${policy}"
      scope_id    = local.scope_id
      template    = try(local.policy_definitions_map[policy], null)
    }
  ]

  policy_set_definitions_output = [
    for policy_set in local.policy_set_names :
    {
      resource_id = "${local.provider_path.policy_definition}${policy_set}"
      scope_id    = var.scope_id
      template    = try(local.policy_set_definitions_map[policy_set], null)
    }
  ]

  azurerm_policy_definition_enterprise_scale = {
    for definition in local.policy_definitions_output :
    definition.resource_id => definition
  }

  azurerm_policy_set_definition_enterprise_scale = {
    for definition in local.policy_set_definitions_output :
    definition.resource_id => definition
  }
}
