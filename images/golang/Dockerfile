# escape=`
FROM powershell:6.1.3 AS builder
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
        'https://dl.google.com/go/go1.12.1.windows-amd64.zip' `
        '2f4849b512fffb2cf2028608aa066cc1b79e730fd146c7b89015797162f08ec5' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/MinGit-2.21.0-64-bit.zip' `
        'bd91db55bd95eaa80687df28877e2df8c8858a0266e9c67331cfddba2735f25c' `
        'git';
RUN ./git/cmd/git config --file git/mingw64/etc/gitconfig core.autocrlf false;

FROM powershell:6.1.3
COPY --from=builder C:/Windows/TEMP/go C:/go
COPY --from=builder C:/Windows/TEMP/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
