#!/bin/bash

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-unify-release
fi

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-convergence.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

echo "run scaling test with tagname=$tagname"

export RUNID=`date +%m%d%H%M%S`

#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
#../bin/xgb-convergence.sh ${bin} synsetmeta 1000 8  lossguide 32 500000 1 0 8 lossguide
../bin/xgb-convergence.sh ${bin} synsetmeta 1000 8 lossguide 32 100000 28 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=1 loadmeta=synsetmeta
../bin/xgb-convergence.sh ${bin} synsetmeta 1000 12 lossguide 32 100000 28 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=synsetmeta
../bin/xgb-convergence.sh ${bin} synsetmeta 1000 16 lossguide 32 100000 28 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=synsetmeta

echo "================================"
echo " Convergence Test Results:"
echo "================================"
echo -e "binname\trunid\ttrainingtime"
#find . -name "Convergence*${tagname}*.csv" -exec cat {} \; |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}' |sort
echo "ls -tr */Convergence*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}'"
ls -tr */Convergence*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}' 

