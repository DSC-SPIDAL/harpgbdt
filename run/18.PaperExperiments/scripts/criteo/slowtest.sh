#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-yfcc-release
fi

tagname=`basename $bin`

echo "run speedup test with tagname=$tagname"

if [ ! -f $bin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

export RUNID=`date +%m%d%H%M%S`
#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"

export RUNID=`date +%m%d%H%M%S`-dp1mix2topk0
../bin/xgb-convergence.sh ${bin} criteometa 20 12 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=criteometa

export RUNID=`date +%m%d%H%M%S`-dp1mix2topk0

../bin/xgb-convergence.sh ${bin} criteometa 20 12 lossguide 32 1562500 2 0 32 depth data_parallelism=0 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=criteometa






export RUNID=`date +%m%d%H%M%S`-dp0mix2topk32

../bin/xgb-convergence.sh ${bin} criteometa 300 12 lossguide 32 1562500 2 0 32 lossguide data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=criteometa

export RUNID=`date +%m%d%H%M%S`-dp1mix0topk32

../bin/xgb-convergence.sh ${bin} criteometa 300 12 lossguide 32 1562500 33 0 4 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=criteometa



echo "ls -tr */Convergence*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}'"
ls -tr */Convergence*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}' 

