cd info

Write-Output 'building the image...'
time {docker build -t csharp-info .}
docker image ls csharp-info
docker history csharp-info

Write-Output 'running the container in foreground...'
time {docker run --rm csharp-info}
