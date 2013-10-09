#Delete a mount and brick, and recreate them using a loopback.
#This script is good for highly simplified development
echo "STARTING TO CREATE A MOUNT" 
if [ "$#" -ne 3 ]
  then
     echo "Usage: mount location, brick location.  "
     echo "For example : /mnt/glusterfs /mnt/mybrick1 MyVolume"
     exit 1 #exit shell script
fi

MNT=$1
BRICK=$2
VOL=$3

read -p "WARNING: DELETING $MNT and $BRICK ... Press a key to continue !"
umount $MNT
rm -rf $MNT
mkdir -p $MNT

umount $BRICK
rm -rf $BRICK
mkdir -p $BRICK

echo "Now creating a file ${BRICK}.raw"

truncate -s 1G ${BRICK}.raw ;


#NOTE: ext4 is not ideal... SHOULD be mkfs.xfs instead of ext4

#ext4 is not recommomended by the gluster team !
mkfs.ext4 ${BRICK}.raw ;

#Here is where the magic happens.

echo "Now mounting the loopback!"
mount -o loop ${BRICK}.raw ${BRICK} ;

echo "Now creating the volume which writes to loopback brick"
gluster volume create $VOL $(hostname):$BRICK

echo "Now starting the volume..."
sleep 1
gluster volume start $VOL

sleep 1
echo "Finally : mounting gluster to $MNT"
mount -t glusterfs $(hostname):$VOL $MNT
