$locname = "Australia East"
$pubname = "RedHat"
$offername = "RHEL"
$skuname = "7.4"
$version = "8.1.0"
#Get-AzureRMVMImagePublisher -Location $locName | Select PublisherName
#Get-AzureRMVMImageOffer -Location $locName -Publisher $pubName | Select Offer
#Get-AzureRMVMImageSku -Location $locName -Publisher $pubName -Offer $offerName | Select Skus
Get-AzureRMVMImage -Location $locName -Publisher $pubName -Offer $offerName -Sku $skuName | Select Version