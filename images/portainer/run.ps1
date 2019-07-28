$hostIp = (Get-NetAdapter -Name 'vEthernet (nat)' | Get-NetIPAddress -AddressFamily IPv4).IPAddress

Write-Output 'Running the portainer container in the background...'
docker `
    run `
    --name portainer `
    --restart unless-stopped `
    -d `
    -v //./pipe/docker_engine://./pipe/docker_engine `
    -p 9000:9000 `
    portainer:1.21.0 `
        -H npipe:////./pipe/docker_engine

$url = 'http://localhost:9000'
Write-Output "Using the container by doing an http request to $url..."
(Invoke-RestMethod $url) -split '\n' | Select-Object -First 8 | ForEach-Object {"    $_"}

Write-Output "Portainer is available at http://${hostIp}:9000"
Write-Output 'Or inside the VM at http://localhost:9000'
