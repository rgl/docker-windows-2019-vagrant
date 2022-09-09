Write-Output 'building the golang image...'
$tag = 'golang:1.19.1'
time {
    docker build `
        --build-arg "WINDOWS_NANOSERVER_IMAGE=$((Get-WindowsContainers).nanoserver)" `
        --build-arg "POWERSHELL_IMAGE=$((Get-WindowsContainers).powershellNanoserver)" `
        -t $tag .
}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the golang container in the foreground...'
time {
    docker run `
        --rm `
        --name golang-smoke-test `
        $tag `
        go env
}
time {
    docker run `
        --rm `
        --name golang-smoke-test `
        $tag `
        git --version
}
time {
    docker run `
        --rm `
        --name golang-smoke-test `
        $tag `
        git config --list --show-origin
}
