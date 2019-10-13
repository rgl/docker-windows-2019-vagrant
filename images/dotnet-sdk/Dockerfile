# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.13/2.1.802-download.md
FROM powershell:6.2.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/a3e45ac9-c70d-4526-b05d-1fe621b146e1/55cce526bf94100d95db61fcf65cc182/dotnet-sdk-2.1.801-win-x64.zip'; `
    $sha512 = '60d4a47a51ff542329a016acc17ab7e2982297242f7943f0346a03d3744808ebb89bdb7083fddeafcdbb9c3616aec2190464965193f9bac8d95e8be9042359cb'; `
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

FROM powershell:6.2.3
COPY --from=builder ["C:/Program Files/dotnet", "C:/Program Files/dotnet"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\Program Files\dotnet' `
    DOTNET_CLI_TELEMETRY_OPTOUT='1'
# bootstrap the sdk.
RUN dotnet new
