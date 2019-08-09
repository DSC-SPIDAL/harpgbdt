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

export RUNID=$tag

../bin/lightgbm-convergence.sh ../bin/lightgbm airline 1000 8 feature 32
../bin/lightgbm-convergence.sh ../bin/lightgbm airline 1000 10 feature 32
../bin/lightgbm-convergence.sh ../bin/lightgbm airline 1000 12 feature 32

../bin/xgb-convergence.sh ${hist} airline 1000 8 hist 32 3125000 8 0 8 lossguide 
../bin/xgb-convergence.sh ${hist} airline 1000 10 hist 32 3125000 8 0 8 lossguide
../bin/xgb-convergence.sh ${hist} airline 1000 12 hist 32 3125000 8 0 8 lossguide
../bin/xgb-convergence.sh ${hist} airline 1000 8 hist 32 3125000 8 0 32 depth 
../bin/xgb-convergence.sh ${hist} airline 1000 10 hist 32 3125000 8 0 32 depth
../bin/xgb-convergence.sh ${hist} airline 1000 12 hist 32 3125000 8 0 32 depth


../bin/xgb-convergence.sh ${bin} airlinemeta 1000 8 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 12 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 10 lossguide 32 3125000 8 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta

../bin/xgb-convergence.sh ${bin} airlinemeta 1000 8 lossguide 32 3125000 8 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 12 lossguide 32 3125000 8 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta
../bin/xgb-convergence.sh ${bin} airlinemeta 1000 10 lossguide 32 3125000 8 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=airlinemeta
