Write-Output 'building the busybox image...'
$tag = 'busybox'
time {
    docker build `
        --build-arg "WINDOWS_NANOSERVER_IMAGE=$((Get-WindowsContainers).nanoserver)" `
        --build-arg "POWERSHELL_IMAGE=$((Get-WindowsContainers).powershellNanoserver)" `
        -t $tag .
}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the busybox container in the foreground...'
time {
    docker run `
        --rm `
        --name busybox-smoke-test `
        $tag `
        busybox
}
