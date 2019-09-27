#!/bin/bash
export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
hist=../bin/xgb-latest

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-scaling.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi


dtag=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"

export RUNID=$dtag-higgs-makemeta
../bin/xgb-speedup-0.sh ${bin} higgs 1 6 lossguide 32 312500 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta
../bin/xgb-speedup-0.sh ${bin} higgs 1 6 lossguide 32 312500 1 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta
../bin/xgb-speedup-0.sh ${bin} higgs 1 6 lossguide 32 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta

../bin/xgb-speedup-0.sh ${bin} higgs 1 6 lossguide 32 125000 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta
../bin/xgb-speedup-0.sh ${bin} higgs 1 6 lossguide 32 125000 1 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta
../bin/xgb-speedup-0.sh ${bin} higgs 1 6 lossguide 32 125000 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 savemeta=higgsmeta

# make pseudo input
python -m runner.makepseudodb --input higgs_train.libsvm --output higgs_pseudo.libsvm
