echo "truncating raw brick"
sudo truncate -s 1G /mnt/brick1.raw ;

echo "mkfs ext4 for /mnt/brick1.raw" ;
yes | sudo mkfs.ext4 /mnt/brick1.raw ;

echo "DONE MAKING EXT4"

echo "Mounting raw brick :: mkdir "
sudo mkdir /mnt/brick1

echo "Mounting raw brick :: mount "
sudo mount -t ext4 -o loop /mnt/brick1.raw /mnt/brick1 ;

echo "Mounting raw brick :: DONE Mounting!!!"
