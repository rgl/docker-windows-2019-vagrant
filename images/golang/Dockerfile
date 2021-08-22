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
        'https://golang.org/dl/go1.17.windows-amd64.zip' `
        '2a18bd65583e221be8b9b7c2fbe3696c40f6e27c2df689bbdcc939d49651d151' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.1/MinGit-2.33.0-64-bit.zip' `
        '220e4606ec857d44f0ce67610bd8194f1c3779fbf85c801e945842e6f1732bdc' `
        'git';
RUN ./git/cmd/git config --file git/etc/gitconfig core.autocrlf false

FROM ${WINDOWS_NANOSERVER_IMAGE}
COPY --from=builder C:/build/go C:/go
COPY --from=builder C:/build/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
