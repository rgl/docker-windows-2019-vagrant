# escape=`
ARG WINDOWS_NANOSERVER_IMAGE
ARG POWERSHELL_IMAGE

FROM ${POWERSHELL_IMAGE} AS builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/build
RUN function Install-Artifact($url, $hash, $to) { `
        Write-Host ('Downloading {0}...' -f $url); `
        Invoke-WebRequest -Uri $url -OutFile artifact.zip; `
        Write-Host ('Verifying if the hash is {0}...' -f $hash); `
        if ((Get-FileHash artifact.zip -Algorithm sha256).Hash -ne $hash) { `
            Write-Host 'FAILED!'; `
            Exit 1; `
        }; `
        Write-Host 'Expanding...'; `
        mkdir -Force $to | Out-Null; `
        Expand-Archive artifact.zip $to; `
        Write-Host 'Removing...'; `
        Remove-Item artifact.zip -Force; `
        Write-Host 'Done.'; `
    }; `
    Install-Artifact `
        'https://go.dev/dl/go1.19.1.windows-amd64.zip' `
        'b33584c1d93b0e9c783de876b7aa99d3018bdeccd396aeb6d516a74e9d88d55f' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.37.3.windows.1/MinGit-2.37.3-64-bit.zip' `
        'cec8d038fadbdd82e269a5c458fd2a62711c1bb9a76c85f07c46de3bff6cdf32' `
        'git';
RUN ./git/cmd/git config --file git/etc/gitconfig core.autocrlf false

FROM ${WINDOWS_NANOSERVER_IMAGE}
COPY --from=builder C:/build/go C:/go
COPY --from=builder C:/build/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
