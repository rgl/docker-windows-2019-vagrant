# escape=`
ARG BUILDER_IMAGE
ARG BASE_IMAGE

FROM ${BUILDER_IMAGE} AS builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN mkdir C:\build | Set-Location; `
    $url = 'https://github.com/rgl/graceful-terminating-gui-application-windows/releases/download/v0.3.0/graceful-terminating-gui-application-windows.zip'; `
    $sha256 = '5ab0a294c401cc498a27341280fa26f5795cdcb72a9c1208a0edd282881e8350'; `
    Write-Host ('Downloading graceful-terminating-gui-application-windows from {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile graceful-terminating-gui-application-windows.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash graceful-terminating-gui-application-windows.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive graceful-terminating-gui-application-windows.zip .; `
    Write-Host 'Removing unneeded files...'; `
    Remove-Item graceful-terminating-gui-application-windows.zip;

FROM ${BASE_IMAGE}
RUN mkdir C:\app C:\host
COPY --from=builder C:\build\graceful-terminating-gui-application-windows.exe C:\app
VOLUME ["C:/host"]
WORKDIR C:/host
ENTRYPOINT ["C:/app/graceful-terminating-gui-application-windows.exe", "600"]
