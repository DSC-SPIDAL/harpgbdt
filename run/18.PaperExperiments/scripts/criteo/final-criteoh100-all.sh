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

export RUNID=$tag-sync

#../bin/xgb-convergence.sh ${hist} criteo 300 8 hist 32 1582500 33 0 8 lossguide 
#../bin/xgb-convergence.sh ${hist} criteo 300 8 hist 32 1582500 33 0 32 depth 
../bin/lightgbm-convergence.sh ../bin/lightgbm criteo 300 8 feature 32

#
#../bin/xgb-convergence.sh ${hist} criteo 300 12 hist 32 15122500 33 0 8 lossguide 
#../bin/xgb-convergence.sh ${hist} criteo 300 12 hist 32 15122500 33 0 32 depth 
../bin/lightgbm-convergence.sh ../bin/lightgbm criteo 300 12 feature 32

#../bin/xgb-convergence.sh ${hist} criteo 300 16 hist 32 15162500 33 0 8 lossguide 
#../bin/xgb-convergence.sh ${hist} criteo 300 16 hist 32 15162500 33 0 32 depth 
../bin/lightgbm-convergence.sh ../bin/lightgbm criteo 300 16 feature 32




