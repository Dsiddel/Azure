###### Parameters ######

$resourceGroup = 'rg-t-ae-citrix'
$routeTable = 'rt-t-ae-Citrix'

$azureDataCenterIpsXmlPath = "C:\PublicIPs_20171205.xml"

###### Main Script ######

$azureRouteTable = Get-AzureRmRouteTable -Name $routeTable -ResourceGroupName $resourceGroup

[xml] $azureDataCenterIps = Get-Content $azureDataCenterIpsXmlPath

foreach ($region in $azureDataCenterIps.AzurePublicIpAddresses.Region)
{
   if ($region.name -eq 'australiaeast' -or $region.name -eq 'australiasoutheast')
   {
      foreach ($iprange in $region.iprange)
      {
         $name = $region.name + '-' + ($iprange.Subnet.Replace('/', '-'))

         Add-AzureRmRouteConfig -Name $name -RouteTable $azureRouteTable -AddressPrefix $iprange.Subnet -NextHopType Internet | Out-Null
      }
   }
}

Add-AzureRmRouteConfig -Name 'AzureKMS' -AddressPrefix 23.102.135.246/32 -NextHopType Internet -RouteTable $azureRouteTable | Out-Null
Add-AzureRmRouteConfig -Name 'Default' -AddressPrefix 0.0.0.0/0 -NextHopType Internet -RouteTable $azureRouteTable | Out-Null

Set-AzureRmRouteTable -RouteTable $azureRouteTable

