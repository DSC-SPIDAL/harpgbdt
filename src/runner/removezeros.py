#!/usr/bin/python
# -*- coding: utf-8 -*-

import logging
import numpy as np
from optparse import OptionParser
import sys, os
from time import time
import datetime

def savedata(outfile, X, Y, removezero=True, fmt='libsvm'):
    with open(outfile, 'w') as outf:
        if fmt=='libsvm':
            for i in range(X.shape[0]):
                vec = X[i]
                ss = str(Y[i])   #label
                for j in range(vec.shape[0]):
                    if vec[j] != 0.0:
                        ss += ' %d:%s'%(j, vec[j])
                    elif not removezero:
                        ss += ' %d:%s'%(j, vec[j])
                recstr = '%s\n'%ss
                outf.write(recstr)

        else:
            for i in range(X.shape[0]):
                rec = ["%s"%(x) for x in X[i]]
                recstr = ','.join(rec) + ',%s'%Y[i] + ',\n'
                outf.write(recstr)




def load_option():
    op = OptionParser()
    op.add_option("--input",
                  action="store", type=str, default="", 
                  help="define the dataset file name.")
    op.add_option("--output",
                  action="store", type=str, default="", 
                  help="define the output file name.")
    op.add_option("--debug",
                  action="store_true", 
                  help="Show debug info.")
    op.add_option("--h",
                  action="store_true", dest="print_help",
                  help="Show help info.")
    
    (opts, args) = op.parse_args()
   
    #set default
    if opts.print_help:
        print(__doc__)
        op.print_help()
        print()
        sys.exit(0)

    return opts

def run(infile, outfile):
    logger.info('Start loading data....')
    #data = load_svmlight_file(infile)

    lineid = 0
    itemcnt = 0
    zerocnt = 0
    
    outf = open(outfile, 'w')
    with open(infile) as inf:
        for line in inf:
            #libsvm format
            items = line.split()
            itemcnt += len(items) - 1

            ss = items[0]
            for item in items[1:]:
                idx, value = item.split(":")
                if float(value) == 0.:
                    zerocnt += 1
                else:
                    ss += ' %s'%item

            recstr = '%s\n'%ss
            outf.write(recstr)

            lineid += 1

            if (lineid % 100000) == 0:
                print '.',

    logger.info('itemcnt = %s, zerocnt = %d', itemcnt, zerocnt)

if __name__=="__main__":
    program = os.path.basename(sys.argv[0])
    logger = logging.getLogger(program)

    # logging configure
    import logging.config
    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')
    logging.root.setLevel(level=logging.DEBUG)
    logger.info("running %s" % ' '.join(sys.argv))

    opt = load_option()

    run(opt.input, opt.output)


