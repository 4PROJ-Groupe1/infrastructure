provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "AzureTerraformGroup" {
  name     = "4PROJ"
  location = "North Europe"
}

resource "azurerm_virtual_network" "AzureTerraformNetwork" {
  name                = "vNetAzure"
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name
  location            = azurerm_resource_group.AzureTerraformGroup.location
  address_space       = ["172.32.0.0/16"]
  depends_on = [azurerm_resource_group.AzureTerraformGroup]

    subnet {
    name           = "ProductionNetworkSubnet"
    address_prefix = "172.32.1.0/24"
  }
}

resource "azurerm_subnet" "AzureTerraformSubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.AzureTerraformGroup.name
  virtual_network_name = azurerm_virtual_network.AzureTerraformNetwork.name
  address_prefixes     = ["172.32.1.0/24"]
}

resource "azurerm_public_ip" "AzureTerraformPubIP" {
  name                = "4PROJ-VPN-IP"
  location            = azurerm_resource_group.AzureTerraformGroup.location
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "AzureTerraformNetworkGateway" {
  name                = "VPNAzureToOnprem"
  location            = azurerm_resource_group.AzureTerraformGroup.location
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku      = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.AzureTerraformPubIP.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.AzureTerraformSubnet.id
  }

}

resource "azurerm_local_network_gateway" "AzureTerraformLocalNetworkGateway" {
  name                = "LocalNetwork"
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name
  location            = azurerm_resource_group.AzureTerraformGroup.location
  gateway_address     = "79.80.64.64"
  address_space       = ["10.0.30.0/24"]
}

resource "azurerm_virtual_network_gateway_connection" "AzureTerraformNetworkGatewayConnection" {
  name                = "AzureToForti"
  location            = azurerm_resource_group.AzureTerraformGroup.location
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.AzureTerraformNetworkGateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.AzureTerraformLocalNetworkGateway.id

  shared_key = "a5e6RYu2hg76q21"
}