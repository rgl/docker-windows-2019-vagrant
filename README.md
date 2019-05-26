This is a Docker on Windows Server 2019 (1809) Vagrant environment for playing with Windows containers.


# Usage

Install the [Base Windows Server 2019 Box](https://github.com/rgl/windows-2016-vagrant).

Install the required plugins:

```bash
vagrant plugin install vagrant-reload
```

Then launch the environment:

```bash
vagrant up --provider=virtualbox # or --provider=libvirt
```

At the end of the provision the [examples](examples/) are run.

The Docker Engine API endpoint is available at http://10.0.0.3:2375.

[Portainer](https://portainer.io/) is available at http://10.0.0.3:9000.

[Windows Admin Center](https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/overview) is available at https://10.0.0.3:8443.

# Graceful Container Shutdown

**Windows containers cannot be gracefully shutdown** because they are forcefully terminated after a while. Check the [moby issue 25982](https://github.com/moby/moby/issues/25982) for progress.

The next table describes whether a `docker stop --time 600 <container>` will graceful shutdown a container that is running a [console](https://github.com/rgl/graceful-terminating-console-application-windows/), [gui](https://github.com/rgl/graceful-terminating-gui-application-windows/), or [service](https://github.com/rgl/graceful-terminating-windows-service/) app.

| base image                                | app     | behavior                                                                                     |
| ----------------------------------------- | ------- | -------------------------------------------------------------------------------------------- |
| mcr.microsoft.com/windows/nanoserver:1809 | console | receives the `CTRL_SHUTDOWN_EVENT` notification but is killed after about 5 seconds          |
| mcr.microsoft.com/windows/servercore:1809 | console | receives the `CTRL_SHUTDOWN_EVENT` notification but is killed after about 5 seconds          |
| mcr.microsoft.com/windows:1809            | console | receives the `CTRL_SHUTDOWN_EVENT` notification but is killed after about 5 seconds          |
| mcr.microsoft.com/windows/nanoserver:1809 | service | receives the `SERVICE_CONTROL_PRESHUTDOWN` notification but is killed after about 15 seconds |
| mcr.microsoft.com/windows/servercore:1809 | service | receives the `SERVICE_CONTROL_PRESHUTDOWN` notification but is killed after about 15 seconds |
| mcr.microsoft.com/windows:1809            | service | receives the `SERVICE_CONTROL_PRESHUTDOWN` notification but is killed after about 20 seconds |
| mcr.microsoft.com/windows/nanoserver:1809 | gui     | fails to run because there is no GUI support libraries in the base image                     |
| mcr.microsoft.com/windows/servercore:1809 | gui     | does not receive the shutdown messages `WM_QUERYENDSESSION` or `WM_CLOSE`                    |
| mcr.microsoft.com/windows:1809            | gui     | does not receive the shutdown messages `WM_QUERYENDSESSION` or `WM_CLOSE`                    |

**NG** setting `WaitToKillServiceTimeout` (e.g. `Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name WaitToKillServiceTimeout -Value '450000'`) does not have any effect on extending the kill service timeout.

**NB** setting `WaitToKillAppTimeout` (e.g. `New-ItemProperty -Force -Path 'HKU:\.DEFAULT\Control Panel\Desktop' -Name WaitToKillAppTimeout -Value '450000' -PropertyType String`) does not have any effect on extending the kill application timeout.

You can launch these example containers from host as:

```bash
vagrant execute --sudo -c '/vagrant/ps.ps1 examples/graceful-terminating-console-application/run.ps1'
vagrant execute --sudo -c '/vagrant/ps.ps1 examples/graceful-terminating-gui-application/run.ps1'
vagrant execute --sudo -c '/vagrant/ps.ps1 examples/graceful-terminating-windows-service/run.ps1'
```

# Docker images

This environment builds and uses the following images:

```
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
busybox-info                               latest              2b78753f7cf4        About an hour ago   251MB
go-info                                    latest              54348d98734c        About an hour ago   253MB
csharp-info                                latest              e6ef24dd8eb9        About an hour ago   320MB
powershell-info                            latest              13ad18d65add        About an hour ago   403MB
batch-info                                 latest              6ce5b2236459        About an hour ago   250MB
portainer                                  1.20.2              5d5153fe940d        About an hour ago   301MB
busybox                                    latest              db9317ea950f        About an hour ago   251MB
golang                                     1.12.5              41bd06a4c751        About an hour ago   803MB
dotnet-sdk                                 2.1.700             2dbcc173e577        About an hour ago   721MB
dotnet-runtime                             2.1.11              4c5611104ad4        About an hour ago   320MB
powershell                                 6.2.1               127aa56aabb3        About an hour ago   399MB
mcr.microsoft.com/windows/nanoserver       1809                bcdfac372cdf        6 days ago          250MB
mcr.microsoft.com/windows/servercore       1809                43c05724e30b        6 days ago          4.56GB
mcr.microsoft.com/windows                  1809                1e9ac19b1d2f        6 days ago          13.1GB
```

# Troubleshoot

* Restart the docker daemon in debug mode and watch the logs:
  * set `"debug": true` inside the `$env:ProgramData\docker\config\daemon.json` file
  * restart docker with `Restart-Service docker`
  * watch the logs with `Get-EventLog -LogName Application -Source docker -Newest 50`
* For more information see the [Microsoft Troubleshooting guide](https://docs.microsoft.com/en-us/virtualization/windowscontainers/troubleshooting) and the [CleanupContainerHostNetworking](https://github.com/Microsoft/Virtualization-Documentation/tree/live/windows-server-container-tools/CleanupContainerHostNetworking) page.

# References

* [Using Insider Container Images](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/using-insider-container-images)
* [Beyond \ - the path to Windows and Linux parity in Docker (DockerCon 17)](https://www.youtube.com/watch?v=4ZY_4OeyJsw)
* [The Internals Behind Bringing Docker & Containers to Windows (DockerCon 16)](https://www.youtube.com/watch?v=85nCF5S8Qok)
* [Introducing the Host Compute Service](https://blogs.technet.microsoft.com/virtualization/2017/01/27/introducing-the-host-compute-service-hcs/)
