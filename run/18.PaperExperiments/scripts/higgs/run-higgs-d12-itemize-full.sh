harpgbt=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-nomembuf-itemize-release

th=(32);
tag=result-higgs-d12/higgs-d12
leaves=4096

##xgb
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-xgbhist-t${thread} -- ../bin/xgb-latest-avx2 higgs.conf num_round=100 \
#    nthread=${thread} tree_method=hist max_depth=0 grow_policy=lossguide max_leaves=${leaves}; done
#
##lightgbm
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-lightgbm-t${thread} -- ../bin/lightgbm config=lightgbm_higgs.conf num_trees=100 \
#    nthread=${thread} tree_learner=feature num_leaves=${leaves};done
#
##harpgbt
#
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-nomembuf-dpK1-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 \
#    node_block_size=1 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done
#
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-nomembuf-mpK1-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=312500 \
#    node_block_size=1 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=0 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done
#


harpgbt=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release

#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-dpK1-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 \
#    node_block_size=1 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done
#
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-dpK1-f4-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=312500 \
#    node_block_size=1 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done
#
#
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-mpK1-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=312500 \
#    node_block_size=1 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=0 group_parallel_cnt=1 topk=1 async_mixmode=2 loadmeta=higgsmeta; done
#
#
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-dpK32-f28-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=625000 \
#    node_block_size=32 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta; done
##
##
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-dpK32-f4-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=625000 \
#    node_block_size=32 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta; done
##
##
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-mpK32-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=1 row_block_size=625000 \
#    node_block_size=32 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=0 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta; done
#
for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-asyncK32-t${thread}-1 -- $harpgbt higgsmeta.conf num_round=100 \
    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 \
    node_block_size=32 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta; done

for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-asyncK32-t${thread}-2 -- $harpgbt higgsmeta.conf num_round=100 \
    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 \
    node_block_size=32 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=higgsmeta; done

#
#
#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-SYNCK32-f28-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=28 row_block_size=312500 \
#    node_block_size=1 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=higgsmeta; done

#for thread in ${th[*]}; do advixe-cl -collect=roofline -project-dir=${tag}-membuf-DPK32-f4n8-t${thread} -- $harpgbt higgsmeta.conf num_round=100 \
#    nthread=${thread} tree_method=lossguide max_depth=0 bin_block_size=0 ft_block_size=4 row_block_size=312500 \
#    node_block_size=8 grow_policy=lossguide max_leaves=${leaves}  data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=higgsmeta; done





