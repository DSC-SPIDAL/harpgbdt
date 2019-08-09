#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-yfcc-release
fi

tagname=`basename $bin`

if [ ! -f $bin ]; then
        echo "Usage: run-convergence.sh <bin>"
        echo "$bin not exist, quit"
        exit -1
fi

echo "run scaling test with tagname=$tagname"

export RUNID=`date +%m%d%H%M%S`

##Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 8 lossguide 32 3125000 8 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 12 lossguide 32 3125000 8 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=1 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 10 lossguide 32 3125000 8 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=1 loadmeta=airlinemeta


../bin/xgb-convergence.sh ${bin} airlinemeta 1000 8 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 12 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 10 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta


echo "ls -tr */Convergence*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}'"
ls -tr */Convergence*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}' 
