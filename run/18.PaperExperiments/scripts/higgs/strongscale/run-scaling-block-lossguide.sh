#!/bin/bash

export _gbtproject_=`pwd`

bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
histbin=../bin/xgb-latest
lightgbmbin=../bin/lightgbm

export RUNID=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"
../bin/xgb-strongscale.sh ${bin} higgsmeta 10 8 lossguide 312500 4 0 32 lossguide data_parallelism=1 group_parallel_cnt=1 topk=32 async_mixmode=2 loadmeta=higgsmeta
../bin/xgb-strongscale.sh ${bin} higgsmeta 10 12 lossguide 312500 28 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta

# hist
../bin/xgb-strongscale.sh ${histbin} higgs 10 8 hist 312500 4 0 32 lossguide
../bin/xgb-strongscale.sh ${histbin} higgs 10 12 hist 312500 32 0 4 lossguide


#lightgbm

#lightgbm
#lightgbm-scaling.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <runid>""
../bin/lightgbm-scaling.sh ${lightgbmbin} higgs 10 8 feature  
../bin/lightgbm-scaling.sh ${lightgbmbin} higgs 10 12 feature 

