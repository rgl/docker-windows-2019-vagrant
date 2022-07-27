# escape=`
ARG POWERSHELL_IMAGE
ARG WINDOWS_NANOSERVER_IMAGE

FROM ${POWERSHELL_IMAGE} AS builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-4716-g31467ddfc.exe'; `
    $sha256 = '137a346a40c0a0facdfc0f10b47ea52e3d4413db2da1e15d1d2093e8ef7f3acb'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM ${WINDOWS_NANOSERVER_IMAGE}
COPY --from=builder /Windows/TEMP/busybox.exe /Windows/System32/
