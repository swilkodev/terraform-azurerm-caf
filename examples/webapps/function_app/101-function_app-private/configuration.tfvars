global_settings = {
  default_region = "region1"
  regions = {
    region1 = "southeastasia"
  }
}

resource_groups = {
  funapp = {
    name   = "funapp-private"
    region = "region1"
  }
  spoke = {
    name   = "spoke"
    region = "region1"
  }
}

# By default asp1 will inherit from the resource group location
app_service_plans = {
  asp1 = {
    resource_group_key = "funapp"
    name               = "asp-simple"

    sku = {
      tier = "Standard"
      size = "S1"
    }
  }
}

function_apps = {
  f1 = {
    name               = "funapp-private"
    resource_group_key = "funapp"
    region             = "region1"

    app_service_plan_key = "asp1"
    storage_account_key  = "sa1"

    # identity = {
    #         type                        = "UserAssigned"
    #         managed_identity_keys       = ["msi_funcapp_weather"]
    # }

    # app_settings = {
    #     "WEBSITE_RUN_FROM_PACKAGE"  =   "1"
    #     "WEBSITE_CONTENTOVERVNET"   =   "1"
    #     "WEBSITE_VNET_ROUTE_ALL"    =   "1"
    #     "WEBSITE_DNS_SERVER"        =   "168.63.129.16"
    # }

    settings = {
      vnet_key   = "spoke"
      subnet_key = "app"

      enabled = true
      #https_only  = true
      #os_type     = "" # Specify blank for windows
      #version = "~3"
    }
  }
}

storage_accounts = {
  sa1 = {
    name               = "funapp-sa1"
    resource_group_key = "funapp"
    region             = "region1"

    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"

    containers = {
      dev = {
        name = "random"
      }
    }

  }
}

vnets = {
  spoke = {
    resource_group_key = "spoke"
    region             = "region1"
    vnet = {
      name          = "spoke"
      address_space = ["10.1.0.0/24"]
    }
    specialsubnets = {}
    subnets = {
      app = {
        name = "app"
        cidr = ["10.1.0.0/28"]
      }
    }

  }

}

network_security_group_definition = {
  # This entry is applied to all subnets with no NSG defined
  empty_nsg = {
  }
}
