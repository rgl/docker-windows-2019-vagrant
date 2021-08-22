# escape=`
ARG POWERSHELL_IMAGE
ARG WINDOWS_NANOSERVER_IMAGE

FROM ${POWERSHELL_IMAGE} AS builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-4264-gc79f13025.exe'; `
    $sha256 = '158be77052f257570e4e925863061f3d55a677db228a9adbcfe2dad071437681'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM ${WINDOWS_NANOSERVER_IMAGE}
COPY --from=builder /Windows/TEMP/busybox.exe /Windows/System32/
