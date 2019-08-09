#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
fi

tagname=`basename $bin`

echo "run speedup test with tagname=$tagname"

if [ ! -f $bin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
#../bin/xgb-convergence.sh ${bin} criteometa 300 8 lossguide 32 1562500 33 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=criteometa

D=(8 12 16)
K=(1 8 16 32)
tag=`date +%m%d%H%M%S`-dp0

for d in ${D[*]}; do

for k in ${K[*]}; do
    export RUNID=$tag-K$k
    ../bin/xgb-convergence.sh ${bin} criteometa 300 $d lossguide 32 1562500 2 0 4 lossguide data_parallelism=0 group_parallel_cnt=32 topk=$k async_mixmode=2 loadmeta=criteometa missing_value=1
done

done


