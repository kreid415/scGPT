#!/bin/sh
QUERY=$1
INDEX_DIR=$2
OUTPUT_DIR=$3

MAX_PARTITION_SIZE=50000

total_num=`wc -l ${INDEX_DIR}/${QUERY}.idx | awk '{ print $1 }'`
total_partition=$(($total_num / $MAX_PARTITION_SIZE))
# echo $total_num
# echo $total_partition"

for i in $(seq 0 $total_partition)
do
    while true;
    do
        echo "downloading partition ${i}/${total_partition} for ${QUERY}"
        python3 ./download_partition.py \
            --query-name ${QUERY} \
            --index-dir ${INDEX_DIR} \
            --output-dir ${OUTPUT_DIR} \
            --partition-idx ${i} \
            --max-partition-size ${MAX_PARTITION_SIZE}
        
        ret=$?
        if [ $ret -eq 0 ]; then
            echo "downloaded succesfully"
            break
        else
            echo "error, retrying"
        fi
    done
done
