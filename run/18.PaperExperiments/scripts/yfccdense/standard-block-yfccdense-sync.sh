#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib


bin=../bin/xgboost-g++-omp-dense-halftrick-short-splitonnode-fitmem-release
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
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 6 lossguide 32 500000 32 0 4 lossguide data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 6 lossguide 32 500000 32 0 32 depth data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0

../bin/xgb-convergence.sh ${hist} yfcc 300 6 hist 32 500000 32 0 4 lossguide data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${hist} yfcc 300 6 hist 32 500000 32 0 32 depth data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0

#../bin/lightgbm-convergence.sh ../bin/lightgbm yfcc 300 6 feature 32


##
## standard dp1f0k1n1
##
#export RUNID=$tag-dp1f0k1n1
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 8 lossguide 32 500000 32 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 9 lossguide 32 500000 32 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 10 lossguide 32 500000 32 0 1 lossguide data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#
##
## standard dp0f1k1n1
##
#export RUNID=$tag-dp0f1k1n1
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 8 lossguide 32 500000 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 9 lossguide 32 500000 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#../bin/xgb-convergence.sh ${bin} yfccmeta 300 10 lossguide 32 500000 1 0 1 lossguide data_parallelism=0 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccmeta missing_value=0
#
#
