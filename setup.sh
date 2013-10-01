#!/usr/bin/env bash

#Copy private key ...
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzI
w+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoP
kcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2
hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NO
Td0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcW
yLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQIBIwKCAQEA4iqWPJXtzZA68mKd
ELs4jJsdyky+ewdZeNds5tjcnHU5zUYE25K+ffJED9qUWICcLZDc81TGWjHyAqD1
Bw7XpgUwFgeUJwUlzQurAv+/ySnxiwuaGJfhFM1CaQHzfXphgVml+fZUvnJUTvzf
TK2Lg6EdbUE9TarUlBf/xPfuEhMSlIE5keb/Zz3/LUlRg8yDqz5w+QWVJ4utnKnK
iqwZN0mwpwU7YSyJhlT4YV1F3n4YjLswM5wJs2oqm0jssQu/BT0tyEXNDYBLEF4A
sClaWuSJ2kjq7KhrrYXzagqhnSei9ODYFShJu8UWVec3Ihb5ZXlzO6vdNQ1J9Xsf
4m+2ywKBgQD6qFxx/Rv9CNN96l/4rb14HKirC2o/orApiHmHDsURs5rUKDx0f9iP
cXN7S1uePXuJRK/5hsubaOCx3Owd2u9gD6Oq0CsMkE4CUSiJcYrMANtx54cGH7Rk
EjFZxK8xAv1ldELEyxrFqkbE4BKd8QOt414qjvTGyAK+OLD3M2QdCQKBgQDtx8pN
CAxR7yhHbIWT1AH66+XWN8bXq7l3RO/ukeaci98JfkbkxURZhtxV/HHuvUhnPLdX
3TwygPBYZFNo4pzVEhzWoTtnEtrFueKxyc3+LjZpuo+mBlQ6ORtfgkr9gBVphXZG
YEzkCD3lVdl8L4cw9BVpKrJCs1c5taGjDgdInQKBgHm/fVvv96bJxc9x1tffXAcj
3OVdUN0UgXNCSaf/3A/phbeBQe9xS+3mpc4r6qvx+iy69mNBeNZ0xOitIjpjBo2+
dBEjSBwLk5q5tJqHmy/jKMJL4n9ROlx93XS+njxgibTvU6Fp9w+NOFD/HvxB3Tcz
6+jJF85D5BNAG3DBMKBjAoGBAOAxZvgsKN+JuENXsST7F89Tck2iTcQIT8g5rwWC
P9Vt74yboe2kDT531w8+egz7nAmRBKNM751U/95P9t88EDacDI/Z2OwnuFQHCPDF
llYOUI+SpLJ6/vURRbHSnnn8a/XG+nzedGH5JGqEJNQsz+xT2axM0/W/CRknmGaJ
kda/AoGANWrLCz708y7VYgAtW2Uf1DPOIYMdvo6fxIB5i9ZfISgcJ/bbCUkFrhoH
+vq/5CIWxCPp0f85R4qxxQ5ihxJ0YDQT9Jpx4TMss4PSavPaBH3RXow5Ohe+bYoQ
NE5OgEXk2wVfZczCZpigBKbKZHNYcelXtTt/nP3rsCuGcM4h53s=
-----END RSA PRIVATE KEY-----" >> /home/vagrant/.ssh/id_rsa
#Copy vagrant credentials to root also, so root
#can easily passwordlessly ssh around:
cp -r /home/vagrant/.ssh /root/.ssh
chmod -R 600 /root/.ssh

#Make vagrant world r/w
chmod -R 777 /vagrant

#IF java is not installed...
yum install -y wget
yum install -y tar

if [ ! -f /vagrant/hbase-0.94.11.tar.gz ]; then
        echo "Downloading hbase"
	wget -q http://apache.mirrors.tds.net/hbase/hbase-0.94.11/hbase-0.94.11.tar.gz -O /vagrant/hbase-0.94.11.tar.gz
fi
echo "Hbase acquired in shared dir"
cp /vagrant/hbase-0.94.11.tar.gz .

echo "Untaring HBase tarball"
tar -zxf hbase-0.94.11.tar.gz
ls -altrh hb*

#Chmod to wide open permissions so anyone can run hbase.
#insecure but no big deal
sudo chmod -R 777 hbase-0.94.11

yum install -y java-1.7.0-openjdk-devel
yum install -y java-1.7.0-openjdk

#Now start back with hbase installation 
mkdir -p /mnt/glusterfs/hbase


# 
rm hbase-0.94.11.tar.gz

if [ ! -e ".bash_profile" ]; then
	cp /vagrant/bash_profile /home/vagrant/.bash_profile
	sudo chmod +x /home/vagrant/.bash_profile
fi

#Make the hbase directories easy to read/write, just in case.
sudo chmod -R 777 /mnt/glusterfs/hbase
sudo chmod -R 777 /home/vagrant/hbase-0.94.11/

#Manually write a very simply /etc/hosts file.  
#Otherwise there'll be all sorts of drama.
sudo echo "127.0.0.1	hmaster" > /etc/hosts

sudo chmod -R 777 /etc/hosts

#echo "Setting hostname to $1"
sudo hostname hmaster

#A quick test ssh to make host key verified
ssh -o StrictHostKeyChecking=no root@hmaster

echo "Starting HBase as root"
#sudo echo "hmaster" > ./hbase-0.94.11/conf/regionservers
cp /vagrant/hbase-site.xml /home/vagrant/hbase-0.94.11/conf/
cp /vagrant/regionservers /home/vagrant/hbase-0.94.11/conf/
cp /vagrant/hbase-env.sh /home/vagrant/hbase-0.94.11/conf/

sudo hostname hmaster

sudo ./hbase-0.94.11/bin/start-hbase.sh


echo -e "Ready!\n"
echo "----------"
echo "For HBase shell, ssh as root and type: 'hbase shell'"
echo "'start-hbase' to start, 'stop-hbase' to stop."
echo -e "----------\n"

#Now, a quick smoke test!
sudo hbase-0.94.11/bin/hbase shell -d <<EOF
create 't1','f1' 
put 't1', 'row1', 'f1:a', 'val1'
scan 't1'
EOF

echo "Test result : $?"
