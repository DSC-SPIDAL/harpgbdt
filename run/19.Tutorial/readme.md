Tutorial
=============

This is a simple tutorial to run experiments of harpgbdt on the higgs dataset.


1. init the env

```
if [ -z $_gbtproject_ ]; then 
    echo 'init the env by run "source gbt-test/bin/init_env.sh" first'
    exit 0
fi

mkdir tutorial
cd tutorial

cp -r $_gbtproject_/run/19.Tutorial/* .
```


3. prepare dataset

```
cd higgs

./get_higgsdata.sh

```

the higgs dataset contains file like these:

    size     file
 5797358182  higgs_train.libsvm
  579733544  higgs_test.libsvm
        586  higgs_valid.libsvm


2. prepare the dataset images

create the meta data files, which are images of the initialized in-memory input data structures.

```
./make-metadata.sh

mkdir tmp
mv SpeedUp-xgboost-g++-omp* tmp

```

3. run the experiments

```
./run-final-sync-higgs.sh
```

4. check the results

```
ls Convergence-*/*time*.csv | xargs cat
```





