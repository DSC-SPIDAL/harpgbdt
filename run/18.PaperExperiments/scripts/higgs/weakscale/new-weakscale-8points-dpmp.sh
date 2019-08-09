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


dtag=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"

depths=(8 12)
threads=(4 8 12 16 20 24 28 32)
#threads=(16 32)
for depth in ${depths[*]}; do
for thread in ${threads[*]}; do
fid=$(echo "$thread/4" |bc)

echo "===========================fid:${fid}===================================="

row=$(echo "312500 * $fid" | bc)
export RUNID=$dtag-higgs${fid}-dp
../bin/xgb-speedup-0.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=1 topk=32 async_mixmode=2 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

export RUNID=$dtag-higgs${fid}-mp
../bin/xgb-speedup-0.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 1 0 32 lossguide data_parallelism=0 group_parallel_cnt=1 topk=32 async_mixmode=2 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

done
done
