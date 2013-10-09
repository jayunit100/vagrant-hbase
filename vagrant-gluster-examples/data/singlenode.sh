#!/bin/bash
/vagrant/util/glusterinstall.sh
chmod -R 777 /vagrant/singlenodesetup.sh
/vagrant/util/_singlenodesetup.sh /mnt/glusterfs /mnt/b1 HadoopVol 
