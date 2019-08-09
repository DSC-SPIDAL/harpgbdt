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

export RUNID=$dtag-higgs${fid}
../bin/xgb-speedup.sh ${hist} higgs 10 $depth hist $thread 312500 4 0 32 lossguide data=higgs-${fid}.libsvm

../bin/lightgbm-speedup.sh ../bin/lightgbm higgs 10 $depth feature $thread $fid

row=$(echo "312500 * $fid" | bc)
export RUNID=$dtag-higgs${fid}-dp
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 28 0 1 lossguide data_parallelism=1 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

export RUNID=$dtag-higgs${fid}-mp
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

export RUNID=$dtag-higgs${fid}-async
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=$thread topk=32 async_mixmode=1 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=$thread topk=32 async_mixmode=1 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

export RUNID=$dtag-higgs${fid}-sync
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 4 0 4 lossguide data_parallelism=1 group_parallel_cnt=$thread topk=32 async_mixmode=0 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 4 0 8 lossguide data_parallelism=1 group_parallel_cnt=$thread topk=32 async_mixmode=0 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

export RUNID=$dtag-higgs${fid}-async-fix
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm

export RUNID=$dtag-higgs${fid}-sync-fix
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 4 0 4 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm
../bin/xgb-speedup.sh ${bin} higgsmeta 10 $depth lossguide $thread $row 4 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=higgsmeta-${fid} data=higgs_pseudo-${fid}.libsvm


done
done
