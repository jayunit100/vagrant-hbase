Vagrant.configure("2") do |config|
  config.vm.box = "vagrant-fedora19B"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/86066173/fedora-19.box"
  config.vm.network :private_network, ip: "10.10.10.11"
  config.vm.synced_folder "./config", "/vagrant"
  config.vm.provision :shell, :path => "setup.sh"
end
