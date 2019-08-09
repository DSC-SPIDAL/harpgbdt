HarpGBT
========
Testbed of gbt optimization project

### Milestones

+ 08142018    Initial proposal of GBT. [link](https://github.iu.edu/pengb/gbt-test/tree/master/doc/init)
+ 09192018    Report on GBT distributed implementations, at the biweekly meeting with Intel Daal Team. [link](https://github.iu.edu/pengb/gbt-test/tree/master/doc/meeting/0919-DistributedGBT-II)
+ 09262018    Report on Histogram in GBT, by Miao
+ 10032018    Survey finish
+ 10172018    Report on basic benchmark on GBT, see [3.BasicBenchmakr](run/3.BasicBenchmark) at tag [basic_benchmark_gbt](https://github.iu.edu/pengb/gbt-test/tree/basic_benchmark_gbt)
+ 10252018    GBT Benchmark update in [google doc](https://docs.google.com/presentation/d/1HS5T9d1aqjoNVTJ1E_2UtntWQNqrvHXi3Vof7c-_eK0/edit?usp=sharing)
+ 11212018    Proposal of block-based parallelism, priliminary results of a simple version (single feature column as a block) [link](https://github.iu.edu/pengb/gbt-test/tree/master/doc/meeting/1121-GBTReport)
+ 11302018    C++ Collective Communication operator, allreduce, rotate, ready, by Chathura. [link](https://github.com/DSC-SPIDAL/harpc)
+ 01072019    Block-based parallelism full version ready and Report at[10.BlockParallelReport](run/10.BlockParallelReport) at tag [block_parallelism_gbt](https://github.iu.edu/pengb/gbt-test/tree/block_parallelism_gbt)
+ 02192019    Intel ShowCase report at[15.IntelShowCase](run/15.IntelShowCase) at tag [unity-02192019](https://github.iu.edu/pengb/gbt-test/tree/unity-02192019)
+ 03192019    [Paper draft v2](doc/paper/draft-v2) with experiments at [16.Final-Sync](run/16.Final-Sync) at tag [sync-03192019](https://github.iu.edu/pengb/gbt-test/tree/sync-03192019)
+ 08082019    update experiments results for the submitted paper at [18.PaperExperiments](run/16.PaperExperiments)

### Tasks To-do list

+ distributed version with block-based kernel
+ pruning of ghsum statistics building process
