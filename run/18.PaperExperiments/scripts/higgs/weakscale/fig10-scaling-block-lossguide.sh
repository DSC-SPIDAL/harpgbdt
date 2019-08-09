#!/bin/bash
export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
fi

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-scaling.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

echo "run scaling test with tagname=$tagname"

export RUNID=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"

#
# async fist
#
../bin/xgb-strongscale.sh ${bin} higgsmeta 10 8 lossguide 312500 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta
../bin/xgb-strongscale.sh ${bin} higgsmeta 10 12 lossguide 312500 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta


../bin/xgb-strongscale.sh ${bin} higgsmeta 10 8 lossguide 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-strongscale.sh ${bin} higgsmeta 10 8 lossguide 312500 1 0 32 lossguide data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta

../bin/xgb-strongscale.sh ${bin} higgsmeta 10 8 lossguide 312500 28 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=higgsmeta

../bin/xgb-strongscale.sh ${bin} higgsmeta 10 12 lossguide 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-strongscale.sh ${bin} higgsmeta 10 12 lossguide 312500 1 0 32 lossguide data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta

../bin/xgb-strongscale.sh ${bin} higgsmeta 10 12 lossguide 312500 28 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=higgsmeta


