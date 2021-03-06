#!/usr/bin/python
# -*- coding: utf-8 -*-

import logging
import numpy as np
from optparse import OptionParser
import sys, os
from time import time
import datetime
from sklearn import metrics
from pandas import read_csv
from xgboost import XGBClassifier 
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import OneHotEncoder
 

def load_option():
    op = OptionParser()
    op.add_option("--eval",
                  action="store", type=str, default="", 
                  help="evaluate on the result predictions.")
    op.add_option("--convert",
                  action="store_true",
                  help="convert the dataset from numpy to libsvm and csv.")
    op.add_option("--trainfile",
                  action="store", type=str, default="", 
                  help="define the train dataset file name, train.cut by default.")
    op.add_option("--testfile",
                  action="store", type=str, default="", 
                  help="define the test dataset file name, test.cut by default.")
    op.add_option("--label_col",
                  action="store", type=int, default=0, 
                  help="define the label column in source .csv file")
    op.add_option("--appname",
                  action="store", type=str, default="", 
                  help="define the application name of this run, null by default.")
    op.add_option("--debug",
                  action="store_true", 
                  help="Show debug info.")
 
    op.add_option("--h",
                  action="store_true", dest="print_help",
                  help="Show help info.")
    
    (opts, args) = op.parse_args()
   
    #type convert
    if not opts.appname:
        opts.appname = 'test'

    #set default
    if opts.print_help:
        print(__doc__)
        op.print_help()
        print()
        sys.exit(0)

    return opts

def runxgb_v0(trainfile, testfile, label_col):

    # label_column specifies the index of the column containing the true label
    #dtrain = xgb.DMatrix('%s?format=csv&label_column=%d'%(trainfile, label_col))
    #dtest = xgb.DMatrix('%s?format=csv&label_column=%d'%(testfile, label_col))
    dtrain = xgb.DMatrix(trainfile)
    dtest = xgb.DMatrix(testfile)


    #param = {'max_depth': 16, 'eta': 0.01, 'silent': 1, 'objective': 'binary:logistic'}
    #param['nthread'] = 4
    #param['eval_metric'] = 'auc'
    #num_round = 1000

    param = {'max_depth': 6, 'eta': 0.1, 'silent': 1, 'objective': 'binary:logistic'}
    param['nthread'] = -1
    param['eval_metric'] = 'auc'
    num_round = 300


    bst = xgb.train(param, dtrain, num_round)

    # this is prediction
    preds = bst.predict(dtest)


    y_test = dtest.get_label()    
    auc_score = metrics.roc_auc_score(y_test, preds)
    logger.info('auc = %f', auc_score)

def loaddata(csvfile):
    # load data
    data = read_csv(csvfile, header=None)
    dataset = data.values
    #dataset = np.loadtxt(csvfile)
    # split data into X and y
    X = dataset[:,1:]
    X = X.astype(float)
    Y = dataset[:,0]

    return X, Y

def savedata(outfile, X, Y, fmt='libsvm'):
    with open(outfile, 'w') as outf:
        if fmt=='libsvm':
            for i in range(X.shape[0]):
                vec = X[i]
                ss = str(Y[i])   #label
                for j in range(vec.shape[0]):
                    #if vec[j] != 0.0:
                    #    ss += ' %d:%s'%(j, vec[j])
                    ss += ' %d:%s'%(j, vec[j])
                recstr = '%s\n'%ss
                outf.write(recstr)

        else:
            for i in range(X.shape[0]):
                rec = ["%s"%(x) for x in X[i]]
                recstr = ','.join(rec) + ',%s'%Y[i] + ',\n'
                outf.write(recstr)

def sStr(vec):
    ss = ''
    for i in range(vec.shape[0]):
        if vec[i] != 0.0:
            ss += ' %d:%s'%(i, vec[i])
    return ss


def runeval(predfile, testfile, label_col):
    data = read_csv(testfile, header=None)
    dataset = data.values
    y_test = dataset[:,-2]

    pred = np.loadtxt(predfile)
    y_pred = np.array([1 if x>0.5 else 0 for x in pred]).reshape((pred.shape[0],1))

    for i in range(5):
        logger.info('ID=%d, Y=%s,X=%s', i, y_test[i],y_pred[i])

    # evaluate predictions
    accuracy = accuracy_score(y_test, y_pred)
    print("Accuracy: %.2f%%" % (accuracy * 100.0))

    auc_score = metrics.roc_auc_score(y_test, y_pred)
    logger.info('auc = %f', auc_score)



def runxgb(trainfile, testfile, label_col, convert_only = False):
    logger.info('Start loading data....')
    X_train, y_train  = loaddata(trainfile)
    X_test, y_test = loaddata(testfile)
    logger.info('X_train: %s, X_test: %s', X_train.shape, X_test.shape)

    #debug
    for i in range(5):
        logger.info('ID=%d, Y=%s,X=%s', i, y_train[i],X_train[i])
    for i in range(5):
        logger.info('ID=%d, Y=%s,X=%s', i, y_test[i],X_test[i])

    #save data
    if not os.path.exists('higgs_train.csv'):
        savedata('higgs_train.csv', X_train, y_train, fmt='csv')
        savedata('higgs_test.csv', X_test, y_test, fmt='csv')
        savedata('higgs_train.libsvm', X_train, y_train, fmt='libsvm')
        savedata('higgs_test.libsvm', X_test, y_test, fmt='libsvm')
    else:
        logger.info('higgs data file exist, skip overwriting')


    if convert_only:
        return

    #train
    #
    #GBM: 100 trees, depth 10, learning rate 0.1
    #
    logger.info('Start training...')
    #model = XGBClassifier(max_depth=10, learning_rate=0.1, n_estimators=100, silent=True, objective='binary:logistic', booster='gbtree', n_jobs=-1, nthread=None, gamma=0, min_child_weight=1, max_delta_step=0, subsample=1, colsample_bytree=1, colsample_bylevel=1, reg_alpha=0, reg_lambda=1)
    model = XGBClassifier(max_depth=6, learning_rate=0.1, n_estimators=300, objective='binary:logistic', n_jobs=-1, subsample = 0.5)
    start = datetime.datetime.now()
    model.fit(X_train, y_train)
    end = datetime.datetime.now()
    #elapsed = (end.microsecond - start.microsecond)/1e6
    elapsed = (end - start).total_seconds()

    logger.info('Training finished, elapsed time=%.4f', elapsed)
    logger.info('model=%s', model)

    # make predictions for test data
    y_pred = model.predict(X_test)


    #debug
    logger.info('True Positive Count = %d', np.sum(y_test[:]>0))
    logger.info('Pred Positive Count = %d', np.sum(y_pred[:]>0))

    for i in range(5):
        logger.info('ID=%d, Y=%s,X=%s', i, y_test[i],y_pred[i])

    predictions = [round(value) for value in y_pred]
    # evaluate predictions
    accuracy = accuracy_score(y_test, predictions)
    print("Accuracy: %.2f%%" % (accuracy * 100.0))

    auc_score = metrics.roc_auc_score(y_test, y_pred)
    logger.info('auc = %f', auc_score)


if __name__=="__main__":
    program = os.path.basename(sys.argv[0])
    logger = logging.getLogger(program)

    # logging configure
    import logging.config
    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')
    logging.root.setLevel(level=logging.DEBUG)
    logger.info("running %s" % ' '.join(sys.argv))

    opt = load_option()

    if opt.eval:
        runeval(opt.eval, opt.testfile, opt.label_col)
    else:
        runxgb(opt.trainfile, opt.testfile, opt.label_col, opt.convert)


