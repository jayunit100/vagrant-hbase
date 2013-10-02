VAGRANTFILE_API_VERSION = "2"
Vagrant.configure("2") do |config|
  vmbox = "vagrant-fedora19B"
  vmboxurl = "https://dl.dropboxusercontent.com/u/86066173/fedora-19.box"

  #First node in the cluster.
  #HMaster
  config.vm.define :hbase1 do |hbase1|
	  hbase1.vm.box = "vagrant-fedora19B"
	  hbase1.vm.box_url = "https://dl.dropboxusercontent.com/u/86066173/fedora-19.box"
	  hbase1.vm.network :private_network, ip: "10.10.10.11"
	  hbase1.vm.synced_folder "./config", "/vagrant"
          hbase1.vm.hostname = "hmaster"
	  hbase1.vm.provision :shell, :path => "setup.sh" #, :args => "hmaster"
  end

#  config.vm.define :gluster2 do |gluster2|
#    gluster2.vm.box = vmbox
#    gluster2.vm.box_url = vmboxurl
#
#    gluster2.vm.host_name = "gluster2"
#    gluster2.vm.network "private_network", ip: "10.10.10.12"
#    gluster2.vm.synced_folder "./data", "/vagrant"
#    gluster2.vm.provision "shell", path: "./data/twonode.sh"
# end

end

