#!/bin/bash
export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
fi

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-scaling.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

echo "run scaling test with tagname=$tagname"

export RUNID=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"

#
# async fist
#
hist=../bin/xgb-latest
../bin/xgb-strongscale.sh ${hist} higgs 10 8 hist 312500 28 0 32 lossguide
../bin/xgb-strongscale.sh ${hist} higgs 10 12 hist 312500 28 0 32 lossguide

#
# lightgbm
#
../bin/lightgbm-scaling.sh ../bin/lightgbm higgs 10 8 feature
../bin/lightgbm-scaling.sh ../bin/lightgbm higgs 10 12 feature




