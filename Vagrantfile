# this is required to be able to configure the hyper-v vm.
ENV['VAGRANT_EXPERIMENTAL'] = 'typed_triggers'

VM_MEMORY_MB = 5*1024
VM_CPUS = 4
VM_PRIVATE_HYPERV_SWITCH_NAME = "docker-windows"
VM_PRIVATE_IP_ADDRESS = "10.0.0.3"

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

  config.vm.provider "hyperv" do |hv, config|
    hv.linked_clone = true
    hv.memory = VM_MEMORY_MB
    hv.cpus = VM_CPUS
    hv.enable_virtualization_extensions = false # nested virtualization.
    hv.vlan_id = ENV["HYPERV_VLAN_ID"]
    # see https://github.com/hashicorp/vagrant/issues/7915
    # see https://github.com/hashicorp/vagrant/blob/10faa599e7c10541f8b7acf2f8a23727d4d44b6e/plugins/providers/hyperv/action/configure.rb#L21-L35
    config.vm.network :private_network, bridge: ENV["HYPERV_SWITCH_NAME"] if ENV["HYPERV_SWITCH_NAME"]
    # copy the files from host to guest.
    # NB this is required because docker build does not work over the SMB share.
    config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [
      ".vagrant/",
      ".git/",
      "*.box"]
    # further configure the VM (e.g. manage the network adapters).
    config.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |trigger|
      trigger.ruby do |env, machine|
        # see https://github.com/hashicorp/vagrant/blob/v2.2.19/lib/vagrant/machine.rb#L13
        # see https://github.com/hashicorp/vagrant/blob/v2.2.19/plugins/kernel_v2/config/vm.rb#L716
        bridges = machine.config.vm.networks.select{|type, options| type == :private_network && options.key?(:hyperv__bridge)}.map do |type, options|
          mac_address_spoofing = false
          mac_address_spoofing = options[:hyperv__mac_address_spoofing] if options.key?(:hyperv__mac_address_spoofing)
          [options[:hyperv__bridge], options[:ip], mac_address_spoofing]
        end
        system(
          'PowerShell',
          '-NoLogo',
          '-NoProfile',
          '-ExecutionPolicy',
          'Bypass',
          '-File',
          'configure-hyperv-vm.ps1',
          machine.id,
          bridges.to_json
        )
      end
    end
  end

  config.vm.network "private_network", ip: VM_PRIVATE_IP_ADDRESS, libvirt__forward_mode: "none", libvirt__dhcp_enabled: false, hyperv__bridge: VM_PRIVATE_HYPERV_SWITCH_NAME
  config.vm.provision "shell", path: "configure-hyperv-guest.ps1", args: [VM_PRIVATE_IP_ADDRESS]
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
