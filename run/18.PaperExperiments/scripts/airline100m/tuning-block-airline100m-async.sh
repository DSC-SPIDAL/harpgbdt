#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
fi

tagname=`basename $bin`

if [ ! -f $bin ]; then
        echo "Usage: run-convergence.sh <bin>"
        echo "$bin not exist, quit"
        exit -1
fi


##Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
#../bin/xgb-convergence.sh ${bin} airlinemeta 1000 8 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=airlinemeta
#../bin/xgb-convergence.sh ${bin} airlinemeta 1000 10 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta


#D=(8 10 12)
D=(8 12)
K=(4)
tag=`date +%m%d%H%M%S`

for d in ${D[*]}; do

for k in ${K[*]}; do
    export RUNID=$tag-K$k-dp1mix2
    ../bin/xgb-convergence.sh ${bin} airlinemeta 1000 $d lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=$k async_mixmode=2 loadmeta=airlinemeta

    export RUNID=$tag-K$k-dp0mix2
    ../bin/xgb-convergence.sh ${bin} airlinemeta 1000 $d lossguide 32 3125000 1 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=$k async_mixmode=2 loadmeta=airlinemeta

    export RUNID=$tag-K$k-dp1mix0
    ../bin/xgb-convergence.sh ${bin} airlinemeta 1000 $d lossguide 32 3125000 1 0 1 lossguide data_parallelism=1 group_parallel_cnt=8 topk=$k async_mixmode=0 loadmeta=airlinemeta

done

done

