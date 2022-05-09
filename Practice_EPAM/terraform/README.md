Outputs:

azure_subnet_id = {
  "bastion_subnet" = "/subscriptions/5cecbbaa-a38e-4827-8324-30600cfe4b44/resourceGroups/TestPractice/providers/Microsoft.Network/virtualNetworks/VNetTest/subnets/AzureBastionSubnet"
  "subnet_1" = "/subscriptions/5cecbbaa-a38e-4827-8324-30600cfe4b44/resourceGroups/TestPractice/providers/Microsoft.Network/virtualNetworks/VNetTest/subnets/subnet_1"
  "subnet_2" = "/subscriptions/5cecbbaa-a38e-4827-8324-30600cfe4b44/resourceGroups/TestPractice/providers/Microsoft.Network/virtualNetworks/VNetTest/subnets/subnet_2"
  "subnet_3" = "/subscriptions/5cecbbaa-a38e-4827-8324-30600cfe4b44/resourceGroups/TestPractice/providers/Microsoft.Network/virtualNetworks/VNetTest/subnets/subnet_3"
}
bastion_pubip = "20.207.83.103"





#Create service principal via az cli
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/5cecbbaa-a38e-4827-8324-30600cfe4b44" --name CloudPipersApp -n http://CloudPipersApp.com | ConvertFrom -Json



Below is output -
appId:
displayName:
name:
password:
tenant:

To verify, just go to App registrations and find the details.

-------

Another way - via GUI, go to App registrations and register application

--------
Way via Terraform -

https://matthewdavis111.com/terraform/terraform-azure-ad-app/