
#
# pure mp, data_parallelism=0 async_mixmode=2
#
dp=$1
mixmode=$2
bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-unify-release

#==========================depth================
ftblksize=(2)

for ft in ${ftblksize[*]}; do

#../bin/xgb-speedup.sh ${bin} synset 10 8 lossguide 32 100000 $ft 0 $node depth data_parallelism=$dp group_parallel_cnt=32 topk=$node async_mixmode=$mixmode savemeta=synsetmeta

../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-unify-release synset.conf num_round=1 nthread=32 tree_method=lossguide max_depth=6 bin_block_size=0 ft_block_size=${ft} row_block_size=312500 node_block_size=32 max_leaves=0 data_parallelism=0 group_parallel_cnt=32 async_mixmode=2 savemeta=synset10mx128meta topk=1

done


