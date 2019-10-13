# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.13/2.1.802-download.md
FROM powershell:6.2.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/77a1fe49-848a-4374-8b99-48d891d61251/bbe0c2a7c8fd7fa3cde3c19e36f26e95/dotnet-sdk-2.1.802-win-x64.zip'; `
    $sha512 = '363c16bb3fb2fe7ce9e7fc874aa685f20a5df6c24d784447c0ede174b0a872b6bd1892d110fa42a7c4b0086176da9076271f9ad3df5102cb0a684ad619bd33b1'; `
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
