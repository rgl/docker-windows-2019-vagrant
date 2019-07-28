# escape=`
FROM powershell:6.2.2 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-3128-g241d4d4ac.exe'; `
    $sha256 = '96570620c23661632b378ffacf86e55efba04e89a0c91fc43ca3c4fe3b2b7fbc'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM mcr.microsoft.com/windows/nanoserver:1809
COPY --from=builder /Windows/TEMP/busybox.exe /Windows/System32/
