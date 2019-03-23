
#
# pure mp, data_parallelism=0 async_mixmode=2
#
dp=$1
mixmode=$2
bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-yfcc-release

#==========================depth================
ftblksize=(1 4 8 16 32 64 128)
nblksize=(1 4 8 16 32 64 128)

for ft in ${ftblksize[*]}; do
for node in ${nblksize[*]}; do

../bin/xgb-speedup.sh ${bin} synsetmeta 10 8 lossguide 32 312500 $ft 0 $node depth data_parallelism=$dp group_parallel_cnt=32 topk=$node async_mixmode=$mixmode loadmeta=synset10mx128meta

done
done

#==========================lossguide================
ftblksize=(1 4 8 16 32 64 128)
nblksize=(1 4 8)

for ft in ${ftblksize[*]}; do
for node in ${nblksize[*]}; do

#../bin/xgb-speedup.sh ${bin} synsetmeta 10 8 lossguide 32 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=32 topk=$node async_mixmode=$mixmode loadmeta=synsetmeta
../bin/xgb-speedup.sh ${bin} synsetmeta 10 8 lossguide 32 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=32 topk=8 async_mixmode=$mixmode loadmeta=synset10mx128meta

done
done


