# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.11/2.1.11.md
FROM powershell:6.2.1 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/e2abeb77-02c9-44e8-ac97-007610b73a18/da40662a3333b8aea5a5cd7bcdd2cc97/dotnet-runtime-2.1.11-win-x64.zip'; `
    $sha512 = 'b5118c4a3532daba32aeab686ec3f21779ad28cfb994446ac02aa1902faddb8b67d383d2b516d4b02538a653e03bd97c4b817c4ffde6b156ed6bcb8d2e7dfffb'; `
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
