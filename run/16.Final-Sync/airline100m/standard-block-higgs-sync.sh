#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib


bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
hist=../bin/xgb-latest


tagname=`basename $bin`

echo "run speedup test with tagname=$tagname"

if [ ! -f $bin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi


tag=`date +%m%d%H%M%S`

#
# d6
#

export RUNID=$tag-d6test
../bin/xgb-convergence.sh ${hist} higgsmeta 1000 6 hist 32 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-convergence.sh ${hist} higgsmeta 1000 6 hist 32 312500 4 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=higgsmeta

../bin/xgb-convergence.sh ${bin} higgsmeta 1000 6 lossguide 32 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 6 lossguide 32 312500 4 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=higgsmeta
../bin/lightgbm-convergence.sh ../bin/lightgbm higgs 1000 16 feature 32


#
# standard dp1f0k1n1
#
export RUNID=$tag-dp1f0k1n1
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 8 lossguide 32 312500 28 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 12 lossguide 32 312500 28 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 16 lossguide 32 1250000 28 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=higgsmeta

#
# standard dp0f1k1n1
#
export RUNID=$tag-dp0f1k1n1
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 8 lossguide 32 312500 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 12 lossguide 32 312500 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-convergence.sh ${bin} higgsmeta 1000 16 lossguide 32 1250000 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=higgsmeta

