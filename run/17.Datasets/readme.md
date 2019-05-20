Datasets
==================

Four datasets are used in the experiments. 

HIGGS[1] and AIRLINE[2] are two standard dataset widely used in GBDT benchmarks. HIGGS is real value dataset with only $7.8\%$ zero values. AIRLINE mainly contains categorical features. After label-encoding or feature bundling on one-hot encoding, the dataset contains 8 real value features, and all records with missing value removed.

CRITEO[3] contains 13 integer features and 26 categorical features for 24 days of click logs. By response value replace encoding, we first calculate the clickthrough rate (CTR) and count for these 26 categorical features from the first ten days. We are then replacing them on the next ten days' data. The whole training data have 1.7 Billion records, where a subset of 50 Million records is select for experiments on a single node. Records with missing value are all preserved.

YFCC100M[4] is a large image dataset with 100 Million images in total. Popescu[5] trained deep learning models to learn 1,570 visual concept on this dataset. We combined the visual concept categories to its top-level hierarchy and selected ''artifact'' to make a binary classification dataset. Features for each image record is a 4K extracted from a VGG model.
We use a subset of 1 Million records for experiments on a single node. 

SYNSET is a synthetic dataset that the feature values are randomly generated following a normal distribution. It has an even feature value distribution and always builds a balanced tree by GBDT which represents an ideal even workload scenario. We use SYNSET for parameter tuning experiments in order to explore the pros and cons of different parallelism mode and block size configurations.

### References

[1]:  HIGGS Dataset. https://archive.ics.uci.edu/ml/datasets/HIGGS. [Online;accessed 15-Apr-2019].

[2]:  AIRLINE  Dataset.   http://stat-computing.org/dataexpo/2009/.   [Online;accessed 15-Apr-2019].

[3]:  CRITEO   Dataset.http://labs.criteo.com/2013/12/download-terabyte-click-logs.  [Online; accessed 15-Apr-2019].

[4]:  YFCC100M Dataset. http://multimediacommons.org/. [Online; accessed15-Apr-2019]

[5]:  A. Popescu, E. Spyromitros-Xioufis, S. Papadopoulos, H. Le Borgne, and I. Kompatsiaris, “Toward an Automatic Evaluation of Retrieval Performance with Large Scale Image Collections,” in Proceedings of the 2015 Workshop on Community-Organized Multimodal Mining: Opportunities for Novel Solutions, New York, NY, USA, 2015, pp. 7–12.


