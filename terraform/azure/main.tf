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
}

resource "azurerm_subnet" "AzureTerraformSubnetProd" {
  name                 = "ProductionNetworkSubnet"
  resource_group_name  = azurerm_resource_group.AzureTerraformGroup.name
  virtual_network_name = azurerm_virtual_network.AzureTerraformNetwork.name
  address_prefixes     = ["172.32.1.0/24"]
}

resource "azurerm_subnet" "AzureTerraformSubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.AzureTerraformGroup.name
  virtual_network_name = azurerm_virtual_network.AzureTerraformNetwork.name
  address_prefixes     = ["172.32.0.0/24"]
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

resource "azurerm_network_interface" "AzureTerraformNIC" {
  name                = "NIC-4PROJ-UBU18-KUBE3"
  location            = azurerm_resource_group.AzureTerraformGroup.location
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name

  ip_configuration {
    name                          = "AzureTerraformNetwork"
    subnet_id                     = azurerm_subnet.AzureTerraformSubnetProd.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "AzureTerraformLinuxVM" {
  name                = "4PROJ-UBU18-KUBE3"
  resource_group_name = azurerm_resource_group.AzureTerraformGroup.name
  location            = azurerm_resource_group.AzureTerraformGroup.location
  size                = "Standard_DS1_v2"
  admin_username      = "max"
  admin_password      = "Administrator7*"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.AzureTerraformNIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}