th=(4 8 16 32 36);

for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=higgs-xgbhist-t${thread} -- ../bin/xgb-latest higgs.conf num_round=100 nthread=${thread} tree_method=hist max_depth=0 grow_policy=lossguide max_leaves=256; done

for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=higgs-dpK32-t${thread} -- ../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release higgsmeta.conf num_round=100 nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=312500 node_block_size=32 grow_policy=lossguide max_leaves=256  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta; done

for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=higgs-mpK32-t${thread} -- ../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release higgsmeta.conf num_round=100 nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=312500 node_block_size=32 grow_policy=lossguide max_leaves=256  data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta; done

for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=higgs-dpK1-t${thread} -- ../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release higgsmeta.conf num_round=100 nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=312500 node_block_size=1 grow_policy=lossguide max_leaves=256  data_parallelism=1 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done

for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=higgs-mpK1-t${thread} -- ../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release higgsmeta.conf num_round=100 nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=312500 node_block_size=1 grow_policy=lossguide max_leaves=256  data_parallelism=0 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done
