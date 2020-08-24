#!/bin/bash

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
# sysbench fileio --threads=1 --file-block-size=4K --file-total-size=50G --file-test-mode=seqwr --file-fsync-all=on run

sudo mkdir /mnt/sysbench
sudo mkdir /mnt/sysbench-results
MNT_DIR="/mnt/sysbench"

# Single, ext4

sudo mkfs -t ext4 ${SINGLE}
sudo mount -t ext4 ${EXT4_MOUNT_OPT} ${SINGLE} ${MNT_DIR}
cd ${MNT_DIR}

for freq in $FSYNC_FREQ; do
	for n_threads in $NUM_THREADS; do
		sysbench fileio --threads=$n_threads --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ../sysbench-results/sin_ext4_${freq}_${n_threads}.out
		printf "Single-ext4, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
		sysbench fileio cleanup
		echo 3 > /proc/sys/vm/drop_caches
	done
done
sudo umount ${SINGLE}

# Single, xfs

sudo mkfs -t xfs ${SINGLE}
sudo mount -t xfs ${XFS_MOUNT_OPT} ${SINGLE} ${MNT_DIR}
cd ${MNT_DIR}

for freq in $FSYNC_FREQ; do
        for n_threads in $NUM_THREADS; do
		sysbench fileio --threads=$n_threads --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ../sysbench-results/sin_xfs_${freq}_${n_threads}.out
                printf "Single-xfs, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
                sysbench fileio cleanup
                echo 3 > /proc/sys/vm/drop_caches
        done
done
sudo umount ${SINGLE}

# HW RAID 5, ext4

sudo mkfs -t ext4 ${HW_RAID5}
sudo mount -t ext4 ${EXT4_MOUNT_OPT_HW5} ${HW_RAID5} ${MNT_DIR}
cd ${MNT_DIR}

for freq in $FSYNC_FREQ
do
        for n_threads in $NUM_THREADS
                do
                        sysbench fileio --threads=$n_threads --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ../sysbench-results/hw5_ext4_${freq}_${n_threads}.out
                        printf "HW_RAID5-ext4, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
                        sysbench fileio cleanup
                        echo 3 > /proc/sys/vm/drop_caches
        done
done
sudo umount ${HW_RAID5}

# HW RAID 5, xfs

sudo mkfs -t xfs ${XFS_MKFS_HW5} ${HW_RAID5}
sudo mount -t xfs ${XFS_MOUNT_OPT_HW5} ${HW_RAID5} ${MNT_DIR}
cd ${MNT_DIR}

for freq in $FSYNC_FREQ
do
        for n_threads in $NUM_THREADS
                do
                        sysbench fileio --threads=$n_threads --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ../sysbench-results/hw5_xfs_${freq}_${n_threads}.out
                        printf "HW_RAID5-xfs, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
                        sysbench fileio cleanup
                        echo 3 > /proc/sys/vm/drop_caches
        done
done
sudo umount ${HW_RAID5}

# Optane, ext4

sudo mkfs -t ext4 ${OPTANE}
sudo mount -t ext4 ${EXT4_MOUNT_OPT} ${OPTANE} ${MNT_DIR}
cd ${MNT_DIR}

for freq in $FSYNC_FREQ
do
        for n_threads in $NUM_THREADS
                do
                        sysbench fileio --threads=$n_threads --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ../sysbench-results/opt_ext4_${freq}_${n_threads}.out
                        printf "Optane-ext4, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
                        sysbench fileio cleanup
                        echo 3 > /proc/sys/vm/drop_caches
        done
done
sudo umount ${OPTANE}

# Optane, xfs

sudo mkfs -t xfs ${OPTANE}
sudo mount -t xfs ${XFS_MOUNT_OPT} ${OPTANE} ${MNT_DIR}
cd ${MNT_DIR}

for freq in $FSYNC_FREQ
do
        for n_threads in $NUM_THREADS
                do
                        sysbench fileio --threads=$n_threads --time=120 --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ../sysbench-results/opt_xfs_${freq}_${n_threads}.out
                        printf "Optane-xfs, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
                        sysbench fileio cleanup
                        echo 3 > /proc/sys/vm/drop_caches
        done
done
sudo umount ${OPTANE}

