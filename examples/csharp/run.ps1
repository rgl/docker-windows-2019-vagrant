cd info

Write-Output 'building the image...'
time {
    docker build `
        --build-arg "DOTNET_SDK_IMAGE=$((Get-WindowsContainers).dotnetSdkNanoserver)" `
        --build-arg "DOTNET_RUNTIME_IMAGE=$((Get-WindowsContainers).dotnetRuntimeNanoserver)" `
        -t csharp-info .
}
docker image ls csharp-info
docker history csharp-info

Write-Output 'running the container in foreground...'
time {docker run --rm csharp-info}
