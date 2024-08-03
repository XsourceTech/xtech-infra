[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
Param(
    [String] $PROJECT_NAME,
    [String] $RESOURCE_GROUP_LOCATION
)

$PROJECT_NAME = $PROJECT_NAME.ToLower()

$RESOURCE_GROUP_NAME = "rg-root-$( $PROJECT_NAME )"
If ((az group list --query "[?name=='${RESOURCE_GROUP_NAME}']" | ConvertFrom-Json).length -eq 0)
{
    Write-Host "Resource group named ${RESOURCE_GROUP_NAME} is creating..."
    az group create --resource-group "${RESOURCE_GROUP_NAME}" --location "$( $RESOURCE_GROUP_LOCATION )"
}
Else
{
    Write-Host "Resource group named ${RESOURCE_GROUP_NAME} already exists..."
}

$STORAGE_ACCOUNT_NAME = "stroot$( $PROJECT_NAME )"
If ((az storage account list -g "${RESOURCE_GROUP_NAME}" --query "[?name=='${STORAGE_ACCOUNT_NAME}']" | ConvertFrom-Json).length -eq 0)
{
    Write-Host "Storage account named ${STORAGE_ACCOUNT_NAME} is creating..."
    az storage account create --name "${STORAGE_ACCOUNT_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --sku Standard_GRS --kind StorageV2 --access-tier Hot --allow-blob-public-access false --https-only true --min-tls-version TLS1_2
}
Else
{
    Write-Host "Storage account named ${STORAGE_ACCOUNT_NAME} already exists..."
}

$CONTAINER_NAME = "ctroot$( $PROJECT_NAME )"
If ((az storage container list --account-name "${STORAGE_ACCOUNT_NAME}" --query "[?name=='${CONTAINER_NAME}']" | ConvertFrom-Json).length -eq 0)
{
    Write-Host "Storage container named ${CONTAINER_NAME} is creating..."
    az storage container create --name "${CONTAINER_NAME}" --account-name "${STORAGE_ACCOUNT_NAME}" --resource-group "${RESOURCE_GROUP_NAME}"
}
Else
{
    Write-Host "Storage container named ${CONTAINER_NAME} already exists..."
}
