VM_MEMORY_MB = 5*1024
VM_CPUS = 4

Vagrant.configure("2") do |config|
  config.vm.box = "windows-2019-amd64"

  config.vm.provider "libvirt" do |lv, config|
    lv.memory = VM_MEMORY_MB
    lv.cpus = VM_CPUS
    lv.cpu_mode = "host-passthrough"
    lv.nested = false
    lv.keymap = "pt"
    config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [
      ".vagrant/",
      ".git/",
      "*.box"]
  end

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.memory = VM_MEMORY_MB
    vb.cpus = VM_CPUS
  end

  config.vm.network "private_network", ip: "10.0.0.3", libvirt__forward_mode: "none", libvirt__dhcp_enabled: false

  config.vm.provision "shell", path: "ps.ps1", args: "provision-containers-feature.ps1"
  config.vm.provision "reload"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-chocolatey.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-base.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-git.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-docker-ce.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/golang/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/busybox/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/batch/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/powershell/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/csharp/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/go/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/sh/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/graceful-terminating-console-application/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/graceful-terminating-windows-service/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/graceful-terminating-gui-application/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "summary.ps1"
end
