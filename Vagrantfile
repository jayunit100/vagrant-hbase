VAGRANTFILE_API_VERSION = "2"
Vagrant.configure("2") do |config|
  vmbox = "vagrant-fedora19B"
  vmboxurl = "https://dl.dropboxusercontent.com/u/86066173/fedora-19.box"

  #First node in the cluster.
  #HMaster
  config.vm.define :hbase1 do |hbase1|
	hbase1.vm.box = vmbox
        hbase1.vm.box_url = vmboxurl  
        hbase1.vm.host_name = "rs1"
 	hbase1.vm.network :private_network, ip: "10.10.10.11"
	hbase1.vm.synced_folder "./config", "/vagrant"
        hbase1.vm.hostname = "rs1"
        hbase1.vm.provision :shell, :path => "setup.sh" ##### :args => "hmaster"
  end

  config.vm.define :hbase2 do |hbase2|
    	hbase2.vm.box = vmbox
    	hbase2.vm.box_url = vmboxurl
    	hbase2.vm.host_name = "hmaster"
    	hbase2.vm.network "private_network", ip: "10.10.10.12"
    	hbase2.vm.synced_folder "./config", "/vagrant"
    	hbase2.vm.provision "shell", path: "setup.sh"
 end

end

