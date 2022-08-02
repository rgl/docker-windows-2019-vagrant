param(
    $vmId,
    $bridgesJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
trap {
    Write-Host "ERROR: $_"
    Write-Host (($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1')
    Write-Host (($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1')
    Exit 1
}

function New-Switch($switchName, $switchIpAddress) {
  $networkAdapterName = "vEthernet ($switchName)"
  $networkAdapterIpAddress = $switchIpAddress
  $networkAdapterIpPrefixLength = 24

  # create the vSwitch.
  if (Hyper-V\Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue) {
    return
  }
  Hyper-V\New-VMSwitch -Name $switchName -SwitchType Internal | Out-Null

  # assign it an host IP address.
  $networkAdapter = Get-NetAdapter $networkAdapterName
  $networkAdapter | New-NetIPAddress `
      -IPAddress $networkAdapterIpAddress `
      -PrefixLength $networkAdapterIpPrefixLength `
      | Out-Null
}

$bridges = ConvertFrom-Json $bridgesJson

$vm = Hyper-V\Get-VM -Id $vmId

# reconfigure the network adapters to use the given switch names.
# NB vagrant has already configured ALL network interfaces to use
#    the $env:HYPERV_SWITCH_NAME switch.
# NB the first network adapter is the vagrant management interface
#    which we do not modify.
$networkAdapters = @(Hyper-V\Get-VMNetworkAdapter -VM $vm | Select-Object -Skip 1)
$networkAdapters | Select-Object -Skip $bridges.Length | ForEach-Object {
    Write-Host "Removing the VM $vmId from the $($_.SwitchName) switch..."
    $_ | Hyper-V\Remove-VMNetworkAdapter
}
for ($n = 0; $n -lt $bridges.Length; ++$n) {
    $bridge = $bridges[$n]
    $switchName = $bridge[0]
    $switchIpAddress = "$((($bridge[1] -split '\.') | Select-Object -First 3) -join '.').1"
    $macAddressSpoofing = $bridge[2]
    New-Switch $switchName $switchIpAddress
    if ($n -lt $networkAdapters.Length) {
        Write-Host "Connecting the VM $vmId to the $switchName switch..."
        $networkAdapter = $networkAdapters[$n]
        $networkAdapter | Hyper-V\Connect-VMNetworkAdapter -SwitchName $switchName
        $networkAdapter | Hyper-V\Set-VMNetworkAdapterVlan -Untagged
    } else {
        Write-Host "Connecting the VM $vmId to the $switchName switch..."
        $networkAdapter = Hyper-V\Add-VMNetworkAdapter `
            -VM $vm `
            -Name $switchName `
            -SwitchName $switchName `
            -Passthru
    }
    $networkAdapter | Hyper-V\Set-VMNetworkAdapter `
        -MacAddressSpoofing "$(if ($macAddressSpoofing) {'On'} else {'Off'})"
}
Write-Host "VM Network Adapters:"
Hyper-V\Get-VMNetworkAdapter -VM $vm
