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

export RUNID=`date +%m%d%H%M%S`
#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
#../bin/xgb-convergence.sh ${bin} yfccmeta 20 8 lossguide 32 500000 32 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=2 loadmeta=yfccsparsemeta
#../bin/xgb-convergence.sh ${bin} yfcc 20 8 lossguide 32 500000 32 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=2 savemeta=yfccsparsemeta missing_value=0

#

rowblksize=125000

../bin/xgb-convergence.sh ${bin} yfccmeta 300 8 lossguide 32 $rowblksize 32 0 8 lossguide data_parallelism=0 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${bin} yfccmeta 300 9 lossguide 32 $rowblksize 32 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${bin} yfccmeta 300 10 lossguide 32 $rowblksize 32 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=yfccmeta missing_value=0

../bin/xgb-convergence.sh ${bin} yfccmeta 300 9 lossguide 32 $rowblksize 32 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=1 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${bin} yfccmeta 300 10 lossguide 32 $rowblksize 32 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=1 loadmeta=yfccmeta missing_value=0


../bin/xgb-convergence.sh ${bin} yfccmeta 300 8 lossguide 32 $rowblksize 32 0 8 depth data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${bin} yfccmeta 300 9 lossguide 32 $rowblksize 32 0 8 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${bin} yfccmeta 300 10 lossguide 32 $rowblksize 32 0 8 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=yfccmeta missing_value=0

../bin/xgb-convergence.sh ${bin} yfccmeta 300 9 lossguide 32 $rowblksize 32 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${bin} yfccmeta 300 10 lossguide 32 $rowblksize 32 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=yfccmeta missing_value=0



../bin/xgb-convergence.sh ${hist} yfcc 300 8 hist 32 500000 32 0 4 lossguide data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${hist} yfcc 300 8 hist 32 500000 32 0 32 depth data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/lightgbm-convergence.sh ../bin/lightgbm yfcc 300 8 feature 32

../bin/xgb-convergence.sh ${hist} yfcc 300 9 hist 32 500000 32 0 4 lossguide data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${hist} yfcc 300 9 hist 32 500000 32 0 32 depth data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/lightgbm-convergence.sh ../bin/lightgbm yfcc 300 9 feature 32


../bin/xgb-convergence.sh ${hist} yfcc 300 10 hist 32 500000 32 0 4 lossguide data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/xgb-convergence.sh ${hist} yfcc 300 10 hist 32 500000 32 0 32 depth data_parallelism=0 group_parallel_cnt=32 topk=4 async_mixmode=2 loadmeta=yfccmeta missing_value=0
../bin/lightgbm-convergence.sh ../bin/lightgbm yfcc 300 10 feature 32
