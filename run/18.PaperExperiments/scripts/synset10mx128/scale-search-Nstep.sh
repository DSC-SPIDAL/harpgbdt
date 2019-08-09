
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

    k=0
    nodes=(1 8 16 32 64 128 256)
    for node in ${nodes[*]}; do
    export RUNID=$tag-K${k}N${node}
    ../bin/xgb-speedup-0.sh ${bin} synsetmeta 10 $depth lossguide $thread 312500 $ft 0 $node depth data_parallelism=$dp group_parallel_cnt=1 topk=$k async_mixmode=$mixmode loadmeta=synset10mx128meta
    done


done


