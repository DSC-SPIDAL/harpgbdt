
blksize=(4 8 16 32 64)

for ft in ${blksize[*]}; do

../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-unify-release synset.conf num_round=1 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=100000 node_block_size=8 grow_policy=lossguide max_leaves=256  data_parallelism=1 group_parallel_cnt=32 topk=1 async_mixmode=1 savemeta=synsetmeta ft_block_size=$ft

done
