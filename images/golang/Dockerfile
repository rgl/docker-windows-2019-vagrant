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
        'https://go.dev/dl/go1.18.4.windows-amd64.zip' `
        'dfb93c517e050ba0cfc066802b38a8e7cda2ef666efd634859356b33f543cc49' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/MinGit-2.37.1-64-bit.zip' `
        'edacf2d5c39555c25a396e0b9d27182ab5587259dc2e824b4490996b373f9300' `
        'git';
RUN ./git/cmd/git config --file git/etc/gitconfig core.autocrlf false

FROM ${WINDOWS_NANOSERVER_IMAGE}
COPY --from=builder C:/build/go C:/go
COPY --from=builder C:/build/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
