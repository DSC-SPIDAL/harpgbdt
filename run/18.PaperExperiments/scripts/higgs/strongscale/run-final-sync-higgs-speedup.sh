#!/bin/bash

export _gbtproject_=`pwd`
export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
histbin=../bin/xgb-latest
lightgbmbin=../bin/lightgbm

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

if [ ! -f $histbin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi
if [ ! -f $lightgbmbin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi


export RUNID=`date +%m%d%H%M%S`
#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
../bin/xgb-speedup.sh ${bin} higgsmeta 100 8 lossguide 32 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-speedup.sh ${bin} higgsmeta 100 8 lossguide 32 312500 4 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=higgsmeta

#../bin/xgb-speedup.sh ${histbin} higgs 100 8  hist 32 500000 1 0 8 lossguide
#../bin/xgb-speedup.sh ${histbin} higgs 100 8  hist 32 500000 1 0 8 depth

#../bin/lightgbm-speedup.sh ${lightgbmbin} higgs 100 8 feature 32

#
# others
#
../bin/xgb-speedup.sh ${bin} higgsmeta 100 12 lossguide 32 312500 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta
../bin/xgb-speedup.sh ${bin} higgsmeta 100 16 lossguide 32 1250000 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta

../bin/xgb-speedup.sh ${bin} higgsmeta 100 12 lossguide 32 312500 28 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=1 loadmeta=higgsmeta
../bin/xgb-speedup.sh ${bin} higgsmeta 100 16 lossguide 32 1250000 28 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=1 loadmeta=higgsmeta


#hist
../bin/xgb-speedup.sh ${histbin} higgs 100 8  hist 32 500000 1 0 8 lossguide
../bin/xgb-speedup.sh ${histbin} higgs 100 12  hist 32 500000 1 0 64 lossguide
../bin/xgb-speedup.sh ${histbin} higgs 100 16  hist 32 500000 1 0 64 lossguide
../bin/xgb-speedup.sh ${histbin} higgs 100 8  hist 32 500000 1 0 8 depth
../bin/xgb-speedup.sh ${histbin} higgs 100 12  hist 32 500000 1 0 64 depth
../bin/xgb-speedup.sh ${histbin} higgs 100 16  hist 32 500000 1 0 64 depth

#lightgbm
../bin/lightgbm-speedup.sh ${lightgbmbin} higgs 100 8 feature 32
../bin/lightgbm-speedup.sh ${lightgbmbin} higgs 100 12 feature 32
../bin/lightgbm-speedup.sh ${lightgbmbin} higgs 100 16 feature 32

