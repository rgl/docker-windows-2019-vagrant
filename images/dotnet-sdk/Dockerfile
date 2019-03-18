# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.9/2.1.9.md
FROM powershell:6.1.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/3efb0407-7ea4-4fb2-9b95-b5e800ed4ecd/1f561858fbc8a4e38abb5f36055885b3/dotnet-sdk-2.1.505-win-x64.zip'; `
    $sha512 = 'aaa2b691f3ac7bdc1ba7edcfabb4c51b53fe1760db529f3ab6e77f0436627b67940f10014d10f3f76b0c77a5f4289b15dc1e525ced1e0c4f0406fd52d9ddb682'; `
    $filename = Split-Path -Leaf $url; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile $filename; `
    Write-Host ('Verifying sha512 ({0})...' -f $sha512); `
    if ((Get-FileHash $filename -Algorithm sha512).Hash -ne $sha512) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive $filename 'C:/Program Files/dotnet'; `
    Write-Host 'Removing...'; `
    Remove-Item $filename -Force;

FROM powershell:6.1.3
COPY --from=builder ["C:/Program Files/dotnet", "C:/Program Files/dotnet"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\Program Files\dotnet' `
    DOTNET_CLI_TELEMETRY_OPTOUT='1'
