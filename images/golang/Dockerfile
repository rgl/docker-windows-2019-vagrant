# escape=`
FROM powershell:6.2.3 AS builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/Windows/TEMP
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
        'https://dl.google.com/go/go1.12.7.windows-amd64.zip' `
        '502712c0e29edc6b9cda6fa5e4b6ff9b36e27d225373baead8708c9634aa8e50' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.22.0.windows.1/MinGit-2.22.0-64-bit.zip' `
        '308ce95b7de5792bed9d56e1af5d2053052ea6347ea0021f74070056684ce3ee' `
        'git';
RUN ./git/cmd/git config --file git/mingw64/etc/gitconfig core.autocrlf false;

FROM powershell:6.2.3
COPY --from=builder C:/Windows/TEMP/go C:/go
COPY --from=builder C:/Windows/TEMP/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
