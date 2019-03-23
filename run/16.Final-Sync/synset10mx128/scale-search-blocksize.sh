
#
# pure mp, data_parallelism=0 async_mixmode=2
#
bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release

#==========================lossguide================

dp=0
mixmode=2
ft=2
T=(16 32 48 64)
depth=8

tag=`date +%m%d%H%M%S`

for thread in ${T[*]}; do

    k=1
    node=1
    export RUNID=$tag-K${k}N${node}
    ../bin/xgb-speedup-0.sh ${bin} synsetmeta 10 $depth lossguide $thread 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=1 topk=$k async_mixmode=$mixmode loadmeta=synset10mx128meta

    k=8
    nodes=(1 4 8)
    for node in ${nodes[*]}; do
    export RUNID=$tag-K${k}N${node}
    ../bin/xgb-speedup-0.sh ${bin} synsetmeta 10 $depth lossguide $thread 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=1 topk=$k async_mixmode=$mixmode loadmeta=synset10mx128meta
    done

    k=32
    nodes=(1 8 16 32)
    for node in ${nodes[*]}; do
    export RUNID=$tag-K${k}N${node}
    ../bin/xgb-speedup-0.sh ${bin} synsetmeta 10 $depth lossguide $thread 312500 $ft 0 $node lossguide data_parallelism=$dp group_parallel_cnt=1 topk=$k async_mixmode=$mixmode loadmeta=synset10mx128meta
    done


done


