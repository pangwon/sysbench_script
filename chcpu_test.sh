# Devices

SINGLE="/dev/sdj"
HW_RAID5="/dev/sdm"
OPTANE="/dev/nvme0n1"

# mkfs options

XFS_MKFS_HW5="-d agsize=209807343616 sunit=256 swidth=1797 -l sunit=256"

# mount options

XFS_MOUNT_OPT_HW5="-o sunit=256 swidth=1792 noquota"
XFS_MOUNT_OPT="-o noquota"
EXT4_MOUNT_OPT_HW5="-o stripe=224 data=ordered"
EXT4_MOUNT_OPT="-o data=ordered"

# sysbench options 
FILE_NUM=128
FILE_SIZE="10G"
IO_SIZE="4K"
FSYNC_FREQ="1 10 40"
NUM_THREADS="2 4 6 8"

sudo mkdir /mnt/sysbench
sudo mkdir /mnt/sysbench-results
MNT_DIR="/mnt/sysbench"

sudo mkfs -t ext4 ${SINGLE}
sudo mount -t ext4 ${EXT4_MOUNT_OPT} ${SINGLE} ${MNT_DIR}
cd ${MNT_DIR}
sudo chcpu -d 20-39
sysbench fileio --threads=20 --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/sin_ext4_10_2_20core.out
sysbench fileio cleanup
sudo chcpu -e 20-39
echo 3 > /proc/sys/vm/drop_caches

sudo umount ${SINGLE}

