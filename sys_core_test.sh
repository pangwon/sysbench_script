#!/bin/bash

# sysbench options 
FILE_NUM=128
FILE_SIZE="10G"
IO_SIZE="4K"
TIME=10
FSYNC_FREQ="1 10 40"
NUM_THREADS_MUL="1 2 3 4"
NUM_CORE="8 2"


# Should modify result directory below to store results right way.

#RES_DIR="/home/oslab/kw/sysbench_results/xfs_hw5"
RES_DIR="/home/dohyun/kw/results"
# Main Loop

for core in $NUM_CORE; do
	case $core in
		"2") chcpu -d 2-7;;
		*);;
	esac
	for freq in $FSYNC_FREQ; do
        	for mul in $NUM_THREADS_MUL; do
			n_threads='expr $core |* $mul'
                	sysbench fileio --threads=$n_threads --time=${TIME} --file-num=${FILE_NUM} --file-block-size=${IO_SIZE} --file-total-size=${FILE_SIZE} --file-test-mode=seqwr --file-fsync-freq=$freq run > ${RES_DIR}/${NUM_CORE}core_${freq}freq_${n_threads}thr.out
                	#printf "Single-ext4, fsync-freq %d, num-threads %d completed\n" $freq $n_threads
                	sysbench fileio cleanup
                	echo 3 > /proc/sys/vm/drop_caches
        	done
	done
done

# Enable all CPU 

chcpu -e 2-7
