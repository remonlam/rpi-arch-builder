# Remove each partition
for v_partition in $(parted -s /dev/sdb print|awk '/^ / {print $1}')
do
   parted -s /dev/sda rm ${v_partition}
done
