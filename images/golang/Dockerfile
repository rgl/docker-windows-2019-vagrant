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
        'https://dl.google.com/go/go1.13.1.windows-amd64.zip' `
        '24cb08d369c1962cccacedc56fd79dc130f623b3b667a316554621ad6ac9b442' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/MinGit-2.23.0-64-bit.zip' `
        '8f65208f92c0b4c3ae4c0cf02d4b5f6791d539cd1a07b2df62b7116467724735' `
        'git';
RUN ./git/cmd/git config --file git/mingw64/etc/gitconfig core.autocrlf false;

FROM powershell:6.2.3
COPY --from=builder C:/Windows/TEMP/go C:/go
COPY --from=builder C:/Windows/TEMP/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
