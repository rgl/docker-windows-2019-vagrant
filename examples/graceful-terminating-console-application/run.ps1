@(
    (Get-WindowsContainers).nanoserver
    (Get-WindowsContainers).servercore
    (Get-WindowsContainers).windows
) | ForEach-Object {
    $title = "graceful-terminating-console-application $_"

    $dataPath = 'C:\graceful-terminating-console-application'
    mkdir -Force $dataPath | Out-Null
    Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-console-application-windows.log"

    Write-Output 'building the container...'
    time {
        docker build `
            --build-arg "BUILDER_IMAGE=$((Get-WindowsContainers).powershellNanoserver)" `
            --build-arg "BASE_IMAGE=$_" `
            -t graceful-terminating-console-application .
    }

    Write-Output 'getting the container history...'
    docker history graceful-terminating-console-application

    Write-Output 'running the container in background...'
    try {docker rm --force graceful-terminating-console-application} catch {}
    # TODO there seems to be an EmulateConsole property that we can pass to docker... check it out! is -t enough?
    time {docker run -d --volume "${dataPath}:C:\host" --name graceful-terminating-console-application graceful-terminating-console-application}

    Write-Output 'sleeping a bit before stopping the container...'
    Start-Sleep -Seconds 15
    Write-Output 'stopping the container...'
    # XXX docker/windows seems to ignore the --time argument...
    docker stop --time 600 graceful-terminating-console-application

    Write-Output "getting the $title container logs..."
    docker logs graceful-terminating-console-application | ForEach-Object {"    $_"}

    Write-Output "getting the $title log file..."
    Get-Content "$dataPath\graceful-terminating-console-application-windows.log"
}
