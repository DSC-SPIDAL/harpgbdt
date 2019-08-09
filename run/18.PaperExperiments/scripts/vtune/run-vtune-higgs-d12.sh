 ./vtune-higgs.sh memory-access higgs lightgbm 10 32 ../bin/lightgbm config=lightgbm_higgs.conf num_trees=10 nthread=32 tree_learner=feature num_leaves=4096

 ./vtune-higgs.sh memory-access higgs xgb-vt  10 32 ../bin/xgb-vt higgs.conf num_round=10 nthread=32 tree_method=hist max_depth=0 grow_policy=lossguide max_leaves=4096

 #MP
 ./vtune-higgs.sh memory-access higgs xgb-block-vt  10 32 ../bin/xgb-block-vt higgsmeta.conf num_round=10 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=312500 node_block_size=1 grow_policy=lossguide max_leaves=4096  data_parallelism=0 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta

 #MP+BLOCK
 ./vtune-higgs.sh memory-access higgs xgb-block-vt  10 32 ../bin/xgb-block-vt higgsmeta.conf num_round=10 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=312500 node_block_size=8 grow_policy=lossguide max_leaves=4096  data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta

 #ASYNC
 ./vtune-higgs.sh memory-access higgs xgb-block-vt  10 32 ../bin/xgb-block-vt higgsmeta.conf num_round=10 nthread=32 tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 node_block_size=32 grow_policy=lossguide max_leaves=4096  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta

