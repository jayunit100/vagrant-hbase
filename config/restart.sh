nohup /home/vagrant/hbase-0.94.11/bin/stop-hbase.sh& 

#REMOVES HBASE TOTALLY.  OBVIOUSLY THIS IS JUST 
#FOR TESTING AND SETUP !!!!!!!!!!!!!!!!!!!!!!!

echo "WARNING :::::::::::::::: REMOVING HBASE DATA ENTIRELY in 5 seconds !!!!!!!!!!!"
sleep 5
rm -rf /mnt/glusterfs/hbase
mkdir /mnt/glusterfs/.archive


echo "NOW KILLING JAVA PROCS FORCEFULLY"
jps

killall -9 java

jps

echo "NOW CLEANING LOGS"

#clean logs
rm -rf /home/vagrant/hbase-0.94.11/logs/*
ssh rs1 rm -rf /home/vagrant/hbase-0.94.11/logs

echo "STARTING HBASE !!!!!!!!!!!!!!!!!"

/home/vagrant/hbase-0.94.11/bin/start-hbase.sh

sleep 3

cat /home/vagrant/hbase-0.94.11/logs/* | grep --color Exception
