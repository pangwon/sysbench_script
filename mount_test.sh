#!/bin/bash

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
# sysbench fileio --threads=1 --file-block-size=4K --file-total-size=50G --file-test-mode=seqwr --file-fsync-all=on run

sudo mkdir /mnt/sysbench
sudo mkdir /mnt/sysbench-results
MNT_DIR="/mnt/sysbench"

sudo mkfs -t ext4 ${SINGLE}
sudo mount -t ext4 ${EXT4_MOUNT_OPT} ${SINGLE} ${MNT_DIR}
cd ${MNT_DIR}
sysbench fileio --threads=2 --time=120 --file-block-size=4K --file-total-size=10G --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/mount_test_ext4_sing.out
sysbench fileio cleanup
echo 3 > /proc/sys/vm/drop_caches
sudo umount ${SINGLE}

sudo mkfs -t xfs ${SINGLE}
sudo mount -t xfs ${XFS_MOUNT_OPT} ${SINGLE} ${MNT_DIR}
cd ${MNT_DIR}
sysbench fileio --threads=2 --time=120 --file-block-size=4K --file-total-size=10G --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/mount_test_xfs_sing.out
sysbench fileio cleanup
echo 3 > /proc/sys/vm/drop_caches
sudo umount ${SINGLE}

sudo mkfs -t ext4 ${HW_RAID5}
sudo mount -t ext4 ${EXT4_MOUNT_OPT_HW5} ${HW_RAID5} ${MNT_DIR}
cd ${MNT_DIR}
sysbench fileio --threads=2 --time=120 --file-block-size=4K --file-total-size=10G --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/mount_test_ext4_hw5.out
sysbench fileio cleanup
echo 3 > /proc/sys/vm/drop_caches
sudo umount ${HW_RAID5}

sudo mkfs -t xfs ${XFS_MKFS_HW5} ${HW_RAID5}
sudo mount -t xfs ${XFS_MOUNT_OPT_HW5} ${HW_RAID5} ${MNT_DIR}
cd ${MNT_DIR}
sysbench fileio --threads=2 --time=120 --file-block-size=4K --file-total-size=10G --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/mount_test_xfs_hw5.out
sysbench fileio cleanup
echo 3 > /proc/sys/vm/drop_caches
sudo umount ${HW_RAID5}

sudo mkfs -t ext4 ${OPTANE}
sudo mount -t ext4 ${EXT4_MOUNT_OPT} ${OPTANE} ${MNT_DIR}
cd ${MNT_DIR}
sysbench fileio --threads=2 --time=120 --file-block-size=4K --file-total-size=10G --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/mount_test_ext4_optane.out
sysbench fileio cleanup
echo 3 > /proc/sys/vm/drop_caches
sudo umount ${OPTANE}

sudo mkfs -t xfs ${OPTANE}
sudo mount -t xfs ${XFS_MOUNT_OPT} ${OPTANE} ${MNT_DIR}
cd ${MNT_DIR}
sysbench fileio --threads=2 --time=120 --file-block-size=4K --file-total-size=10G --file-test-mode=seqwr --file-fsync-freq=10 run > ../sysbench-results/mount_test_xfs_optane.out
sysbench fileio cleanup
echo 3 > /proc/sys/vm/drop_caches
sudo umount ${OPTANE}




