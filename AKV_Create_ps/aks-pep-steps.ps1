#### Parameters

$keyvaultname = "aks-cluster-vault"
$location = "CentralIndia"
$keyvaultrg = "aks-rg"
$sshkeysecret = "akssshpubkey"
$spnclientid = "c18d5f03-cac3-49c5-8628-cf729166160d"
$clientidkvsecretname = "spn-id"
$spnclientsecret = "pjhVZrO~lWV6WsqgMNsN0UD8l-v.29IRex"
$spnkvsecretname = "spn-secret"
$spobjectID = "70caf946-5a0f-4f75-bf2c-b7d12a1276f4"
## User's EPAM ID ##
$userobjectid = "a7d99beb-e9b4-4221-8885-c773c2112a89"


#### Create Key Vault

New-AzResourceGroup -Name $keyvaultrg -Location $location

New-AzKeyVault -Name $keyvaultname -ResourceGroupName $keyvaultrg -Location $location

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -UserPrincipalName $userobjectid -PermissionsToSecrets get,set,delete,list

#### create an ssh key for setting up password-less login between agent nodes.

ssh-keygen  -f ~/.ssh/id_rsa_terraform


#### Add SSH Key in Azure Key vault secret

$pubkey = cat ~/.ssh/id_rsa_terraform.pub

$Secret = ConvertTo-SecureString -String $pubkey -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $sshkeysecret -SecretValue $Secret


#### Store service principal Client id in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientid -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $clientidkvsecretname -SecretValue $Secret


#### Store service principal Secret in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientsecret -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $spnkvsecretname -SecretValue $Secret


#### Provide Keyvault secret access to SPN using Keyvault access policy

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -ServicePrincipalName $spobjectID -PermissionsToSecrets Get,Set