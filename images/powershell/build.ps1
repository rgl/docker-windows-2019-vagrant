$version = '6.2.0'
$sha256 = 'c02af438d3bc8dc61815110c99189a694ed161e64c64a59b49ab01d945dfc73a'
$url = "https://github.com/PowerShell/PowerShell/releases/download/v$version/PowerShell-$version-win-x64.zip"
$filename = "$PWD\$(Split-Path -Leaf $url)"

if (!(Test-Path $filename)) {
    Write-Host "Downloading PowerShell from $url..."
    (New-Object System.Net.WebClient).DownloadFile($url, $filename)
}
Write-Host "Verifying sha256 ($sha256)..."
if ((Get-FileHash $filename -Algorithm sha256).Hash -ne $sha256) {
    Write-Host 'FAILED! Please remove the file and try again...'
    Exit 1
}

Write-Output 'building the powershell image...'
$tag = "powershell:$version"
time {docker build -t $tag --build-arg POWERSHELL_VERSION=$version .}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the powershell container in the foreground...'
time {
    docker run `
        --rm `
        --name powershell-smoke-test `
        $tag `
        pwsh.exe `
        -Command '\"PATH environment variable items\";\"-------------------------------\";$env:PATH -split \";\";$PSVersionTable'
}
