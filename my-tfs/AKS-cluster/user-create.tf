resource "random_string" "password" {
  length  = 8
  special = true
}

resource "random_uuid" "uuid1" {}
resource "random_uuid" "uuid2" {}
resource "random_uuid" "uuid3" {}
resource "random_uuid" "uuid4" {}

resource "azuread_user" "user" {
  user_principal_name   = "${var.username}${random_id.random_id.hex}@qloudabletraininglabs.onmicrosoft.com"
  display_name          = "${var.username}${random_id.random_id.hex}"
  mail_nickname         = "${var.username}${random_id.random_id.hex}"
  password              = "${random_string.password.result}@${random_id.random_id.hex}"
  force_password_change = false
}
resource "azurerm_role_definition" "role_definition" {
  role_definition_id = "${random_uuid.uuid1.result}"
  name               = "${var.username}${random_id.random_id.hex}_customrole"
  scope              = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.resource_group.name}"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action",
      "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
    ]

    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.resource_group.name}",
  ]
}

resource "azurerm_role_assignment" "role_assignment" {
  name               = "${random_uuid.uuid2.result}"
  scope              = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.resource_group.name}"
  role_definition_id = "${azurerm_role_definition.role_definition.id}"
  principal_id       = "${azuread_user.user.id}"
}

resource "azurerm_role_definition" "role_definition2" {
  role_definition_id = "${random_uuid.uuid3.result}"
  name               = "${var.username}${random_id.random_id.hex}_customrole2"
  scope              = "/subscriptions/${var.subscription_id}/resourceGroups/MC_${azurerm_resource_group.resource_group.name}_${azurerm_kubernetes_cluster.aks_cluster.name}_${azurerm_resource_group.resource_group.location}"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/networkInterfaces/read",
      "Microsoft.Network/networkSecurityGroups/read",
      "Microsoft.Network/routeTables/read",
      "Microsoft.Compute/availabilitySets/read",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/disks/read",
      "Microsoft.Network/loadBalancers/read",
    ]

    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}/resourceGroups/MC_${azurerm_resource_group.resource_group.name}_${azurerm_kubernetes_cluster.aks_cluster.name}_${azurerm_resource_group.resource_group.location}",
  ]
}

resource "azurerm_role_assignment" "role_assignment2" {
  name               = "${random_uuid.uuid4.result}"
  scope              = "/subscriptions/${var.subscription_id}/resourceGroups/MC_${azurerm_resource_group.resource_group.name}_${azurerm_kubernetes_cluster.aks_cluster.name}_${azurerm_resource_group.resource_group.location}"
  role_definition_id = "${azurerm_role_definition.role_definition2.id}"
  principal_id       = "${azuread_user.user.id}"
}
