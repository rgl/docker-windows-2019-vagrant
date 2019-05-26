# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.700-SDK/2.1.700-SDK-download.md
FROM powershell:6.2.1 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/576e0421-9f66-4849-9abf-3ecc1447d4c3/a2903a5f7371df668f0d8f7f33938a0b/dotnet-sdk-2.1.700-win-x64.zip'; `
    $sha512 = 'e3258e6a33cce5bcae6f6d00cff39bc5f2bdb522deca855c97975ddd60c5db2f90cbd2e2cc2022533a65076307756bac79f93bf156da14aafffa0bd0ae1f0919'; `
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

FROM powershell:6.2.1
COPY --from=builder ["C:/Program Files/dotnet", "C:/Program Files/dotnet"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\Program Files\dotnet' `
    DOTNET_CLI_TELEMETRY_OPTOUT='1'
