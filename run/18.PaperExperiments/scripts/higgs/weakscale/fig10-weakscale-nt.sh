#!/bin/bash
export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
hist=../bin/xgb-latest

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-scaling.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi


export RUNID=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"

#threads=(8 16 32)
threads=(16 32)
for thread in ${threads[*]}; do
fid=$(echo "$thread/8" |bc)

echo "===========================fid:${fid}===================================="

row=$(echo "312500 * $fid" | bc)
../bin/xgb-speedup-0.sh ${bin} higgs 10 8 lossguide $thread $row 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta-${fid} data=higgs-${fid}.libsvm

#../bin/xgb-speedup-0.sh ${hist} higgs 10 8 hist $thread 312500 4 0 32 lossguide data=higgs-${fid}.libsvm


#../bin/lightgbm-speedup-0.sh ../bin/lightgbm higgs 10 8 feature $thread $fid

done

