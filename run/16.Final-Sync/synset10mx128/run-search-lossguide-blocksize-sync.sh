
#
# pure mp, data_parallelism=0 async_mixmode=2
#
#dp=$1
#mixmode=$2
bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

run_lossguide()
{
dp=$1
mixmode=$2
depth=$3


#==========================lossguide================
ftblksize=(1 4 8 16 32 64 128)
nblksize=(1 4 8 16 32)

for ft in ${ftblksize[*]}; do
for node in ${nblksize[*]}; do

#../bin/xgb-speedup.sh ${bin} synsetmeta 10 8 lossguide 32 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=32 topk=$node async_mixmode=$mixmode loadmeta=synsetmeta
#../bin/xgb-speedup.sh ${bin} synsetmeta 10 8 lossguide 32 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=32 topk=32 async_mixmode=$mixmode loadmeta=synset10mx128meta
../bin/xgb-speedup.sh ${bin} synsetmeta 10 $depth lossguide 32 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=32 topk=32 async_mixmode=$mixmode loadmeta=synset10mx128meta

done
done

saveresult lossguide $dp $mixmode $depth
}

run_depth()
{
dp=$1
mixmode=$2

#==========================depth================
ftblksize=(1 4 8 16 32 64 128)
nblksize=(1 4 16 64 256 1024 4096)

for ft in ${ftblksize[*]}; do
for node in ${nblksize[*]}; do

../bin/xgb-speedup.sh ${bin} synsetmeta 10 12 lossguide 32 312500 $ft 0 $node depth data_parallelism=$dp group_parallel_cnt=32 topk=$node async_mixmode=$mixmode loadmeta=synset10mx128meta

done
done


saveresult depth $dp $mixmode

}

saveresult()
{
    dirname=$1-dp$2-mix$3-d$4
    mkdir -p $dirname
    mv Speed* $dirname
    mv *.log $dirname 
}

#
#
#
run_lossguide 0 2 8
run_lossguide 1 2 8
run_lossguide 0 2 12
run_lossguide 1 2 12





