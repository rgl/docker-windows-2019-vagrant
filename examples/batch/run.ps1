cd info

Write-Output 'building the image...'
time {
    docker build `
        --build-arg "WINDOWS_NANOSERVER_IMAGE=$((Get-WindowsContainers).nanoserver)" `
        -t batch-info .
}
docker image ls batch-info
docker history batch-info

Write-Output 'running the container in foreground...'
time {docker run --rm batch-info}
