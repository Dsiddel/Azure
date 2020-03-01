# Dependency Check
try {
    Import-Module -Name Az -Version 2.0.0
} catch {
    throw "Unable to import AZ Module, please install it using Install-module AZ -version 2.0.0 and run the script again"
}
# Global Variables
$Regionname = $null
$Publishername = $null
$Offername = $null
$SKUname = $null
$Version = $null

#Function List
function Login-Azure {
    Write-Host "Please Login to Azure with your credentials"
    Login-AzAccount
}
function Select-Region {
    $regions = Get-AzLocation -WarningAction SilentlyContinue
    if ($regions -eq $null) {
        throw "You don't have access to any regions, please check your Azure AD Credentials"
    }
    $num = 1
    $regionlist = New-Object 'System.Collections.Generic.List[object]'
    foreach ($region in $regions) {
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name 'Option' -Value $num
        $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $region.DisplayName
        $obj | Add-Member -MemberType NoteProperty -Name 'Location' -Value $region.Location
        $num++
        $regionlist.add($obj)
    }
    Write-Host "Please Select the Region you want to check:"
    foreach ($regl in $regionlist) {
        Write-Host $regl.option")"$regl.Name
        }
    $selectedregionNumber = Read-Host -Prompt "Please select region by entering it's number"
    $selectedregion = $regionlist | Where-Object {$_.Option -eq $selectedregionNumber};
    if ($selectedregion -eq $null){
        Write-Host "You have not selected a valid Region number please select again"
        Select-Region
    } else {
        $confirm = Read-Host "You selected $selectedregionNumber)"$selectedregion.Name" is this correct [y/n]?"
        if ($confirm -eq "y") {
            return $selectedregion.Location
        } else {
            Select-Region
        }
    }    
}

function Select-Publishername ($regionname) {
    $publishers = Get-AzVMImagePublisher -Location $regionname -WarningAction SilentlyContinue
    if ($publishers -eq $null) {
        throw "You don't have access to any regions, please check your Azure AD Credentials"
    }
    $num = 1
    $pubisherlist = New-Object 'System.Collections.Generic.List[object]'
    foreach ($publisher in $publishers) {
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name 'Option' -Value $num
        $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $publisher.PublisherName
        $num++
        $pubisherlist.add($obj)
    }
    Write-Host "Please Select the Publisher you want to check:"
    foreach ($publ in $pubisherlist) {
        Write-Host $publ.option")"$publ.Name
        }
    $selectedpublisherNumber = Read-Host -Prompt "Please select publisher by entering it's number"
    $selectedpublisher = $pubisherlist | Where-Object {$_.Option -eq $selectedpublisherNumber};
    if ($selectedpublisher -eq $null){
        Write-Host "You have not selected a valid Publisher number please select again"
        Select-Publishername
    } else {
        $confirm = Read-Host "You selected $selectedpublisherNumber)"$selectedpublisher.Name" is this correct [y/n]?"
        if ($confirm -eq "y") {
            return $selectedpublisher.Name
        } else {
            Select-Publishername
        }
    }    
}

function Select-Imageoffer ($regionname, $publishername) {
    $imageoffers = Get-AzVMImageOffer -Location $regionname -PublisherName $publishername -WarningAction SilentlyContinue
    if ($imageoffers -eq $null) {
        throw "You don't have access to any regions, please check your Azure AD Credentials"
    }
    $num = 1
    $imagelist = New-Object 'System.Collections.Generic.List[object]'
    foreach ($image in $imageoffers) {
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name 'Option' -Value $num
        $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $image.Offer
        $num++
        $imagelist.add($obj)
    }
    Write-Host "Please Select the Image Offer you want to check:"
    foreach ($imagel in $imagelist) {
        Write-Host $imagel.option")"$imagel.Name
        }
    $selectedimageNumber = Read-Host -Prompt "Please select image by entering it's number"
    $selectedimage = $imagelist | Where-Object {$_.Option -eq $selectedimageNumber};
    if ($selectedimage -eq $null){
        Write-Host "You have not selected a valid image number please select again"
        Select-Imageoffer
    } else {
        $confirm = Read-Host "You selected $selectedimageNumber)"$selectedimage.Name" is this correct [y/n]?"
        if ($confirm -eq "y") {
            return $selectedimage.Name
        } else {
            Select-Imageoffer
        }
    }    
}

function Select-SKU ($regionname, $publishername, $offername) {
    $skunames = Get-AzVMImageSku -Location $regionname -PublisherName $publishername -Offer $offername -WarningAction SilentlyContinue
    if ($skunames -eq $null) {
        throw "You don't have access to any sku's, please check your Azure AD Credentials"
    }
    $num = 1
    $skulist = New-Object 'System.Collections.Generic.List[object]'
    foreach ($sku in $skunames) {
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name 'Option' -Value $num
        $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $sku.Skus
        $num++
        $skulist.add($obj)
    }
    Write-Host "Please Select the sku you want to check:"
    foreach ($skul in $skulist) {
        Write-Host $skul.option")"$skul.Name
        }
    $selectedskuNumber = Read-Host -Prompt "Please select sku by entering it's number"
    $selectedsku = $skulist | Where-Object {$_.Option -eq $selectedskuNumber};
    if ($selectedsku -eq $null){
        Write-Host "You have not selected a valid sku number please select again"
        Select-SKU
    } else {
        $confirm = Read-Host "You selected $selectedskuNumber)"$selectedsku.Name" is this correct [y/n]?"
        if ($confirm -eq "y") {
            return $selectedsku.Name
        } else {
            Select-SKU
        }
    }    
}

function Select-Version ($regionname, $publishername, $offername, $skuname) {
    $versionnames = Get-AzVMImage -Location $regionname -PublisherName $publishername -Offer $offername -Sku $skuname -WarningAction SilentlyContinue
    if ($versionnames -eq $null) {
        throw "You don't have access to any versions, please check your Azure AD Credentials"
    }
    $num = 1
    $versionlist = New-Object 'System.Collections.Generic.List[object]'
    foreach ($version in $versionnames) {
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name 'Option' -Value $num
        $obj | Add-Member -MemberType NoteProperty -Name 'Name' -Value $version.Version
        $num++
        $versionlist.add($obj)
    }
    Write-Host "Please Select the version you want to check:"
    foreach ($versionl in $versionlist) {
        Write-Host $versionl.option")"$versionl.Name
        }
    $selectedversionNumber = Read-Host -Prompt "Please select version by entering it's number"
    $selectedversion = $versionlist | Where-Object {$_.Option -eq $selectedversionNumber};
    if ($selectedversion -eq $null){
        Write-Host "You have not selected a valid version number please select again"
        Select-Version
    } else {
        $confirm = Read-Host "You selected $selectedversionNumber)"$selectedversion.Name" is this correct [y/n]?"
        if ($confirm -eq "y") {
            return $selectedversion.Name
        } else {
            Select-Version
        }
    }    
}


# Core Script
Login-Azure
$Regionname = Select-Region
$Publishername = Select-Publishername -regionname $Regionname
$Offername = Select-Imageoffer -regionname $Regionname -publishername $Publishername
$SKUname =  Select-SKU -regionname $Regionname -publishername $Publishername -offername $Offername
$Version =  Select-Version -regionname $Regionname -publishername $Publishername -offername $Offername -skuname $SKUname


Write-Host "Here are your selections"
Write-Host "Region is $Regionname"
Write-Host "Publishername is $Publishername"
Write-Host "Offername is $Offername"
Write-Host "SKUname is $SKUname"
Write-Host "Version is $Version"
