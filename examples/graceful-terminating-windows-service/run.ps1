@(
    (Get-WindowsContainers).powershellNanoserver
    (Get-WindowsContainers).servercore
    (Get-WindowsContainers).server
) | Where-Object {$_} | ForEach-Object {
    $dockerfile = Get-Content -Raw Dockerfile
    if ($_ -match 'powershell:') {
        $dockerfile = $dockerfile -replace 'PowerShell','pwsh'
    }
    Set-Content `
        -Encoding utf8 `
        -Path Dockerfile.tmp `
        -Value $dockerfile
    $title = "graceful-terminating-windows-service $_"

    $dataPath = 'C:\graceful-terminating-windows-service'
    mkdir -Force $dataPath | Out-Null
    Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-windows-service.log"

    Write-Output 'building the container...'
    Write-Output "using BUILDER_IMAGE: $((Get-WindowsContainers).powershellNanoserver)"
    Write-Output "using BASE_IMAGE: $_"
    time {
        docker build `
            --build-arg "BUILDER_IMAGE=$((Get-WindowsContainers).powershellNanoserver)" `
            --build-arg "BASE_IMAGE=$_" `
            --file Dockerfile.tmp `
            -t graceful-terminating-windows-service `
            .
    }

    Write-Output 'getting the container history...'
    docker history graceful-terminating-windows-service

    Write-Output 'running the container in background...'
    try {docker rm --force graceful-terminating-windows-service} catch {}
    time {docker run -d --volume "${dataPath}:C:\host" --name graceful-terminating-windows-service graceful-terminating-windows-service}

    Write-Output 'sleeping a bit before stopping the container...'
    Start-Sleep -Seconds 15
    Write-Output 'stopping the container...'
    docker stop --time 600 graceful-terminating-windows-service

    Write-Output "getting the $title container logs..."
    docker logs graceful-terminating-windows-service | ForEach-Object {"    $_"}

    Write-Output "getting the $title log file..."
    Get-Content "$dataPath\graceful-terminating-windows-service.log"
}
