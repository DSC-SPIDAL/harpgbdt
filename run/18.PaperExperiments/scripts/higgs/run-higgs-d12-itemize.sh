

#MP
../bin/xgb-block higgsmeta.conf num_round=100 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=312500 node_block_size=1 grow_policy=lossguide max_leaves=4096  data_parallelism=0 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta

#MP+BLOCK
../bin/xgb-block higgsmeta.conf num_round=100 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=312500 node_block_size=8 grow_policy=lossguide max_leaves=4096  data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta

#ASYNC
../bin/xgb-block higgsmeta.conf num_round=100 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 node_block_size=32 grow_policy=lossguide max_leaves=4096  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta
