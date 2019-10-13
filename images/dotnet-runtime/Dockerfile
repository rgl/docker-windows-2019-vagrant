# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.12/2.1.801-sdk-download.md
FROM powershell:6.2.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/dcf8c839-2ffd-4677-9b29-4af9c44e170e/59de767034f66051fe6eab61fa757be1/dotnet-runtime-2.1.12-win-x64.zip'; `
    $sha512 = 'ce3f8abd92997645035b7655e9ae61e2023ffc9848b250945e140bfd05c26beed35982e8f5a5d263bc576112c6f4d3e82b0bea45bd07d5331f290c1d8d2eb9ce'; `
    $filename = Split-Path -Leaf $url; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile $filename; `
    Write-Host ('Verifying sha512 ({0})...' -f $sha512); `
    if ((Get-FileHash $filename -Algorithm sha512).Hash -ne $sha512) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive $filename dotnet; `
    Write-Host 'Removing...'; `
    Remove-Item $filename -Force;

FROM mcr.microsoft.com/windows/nanoserver:1809
COPY --from=builder ["C:/Windows/TEMP/dotnet", "C:/Program Files/dotnet"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\Program Files\dotnet' `
    DOTNET_CLI_TELEMETRY_OPTOUT='1'
