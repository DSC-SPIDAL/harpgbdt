ls -tr SpeedUp-xgboost-g++-omp-dense-halftrick-byte-splitonnode-yfcc-release-synsetmeta-n10-d12-mlossguide-t32-b0-f*/*time*.csv |xargs cat >synset10mx128-d12-blocksize.time
cp synset10mx128-d12-blocksize.time d12.time
sed -i 's/-f/-f,/g' d12.time 
sed -i 's/-x/-x,/g' d12.time 
sed -i 's/-r/,-r/g' d12.time 
sed -i 's/-g/,-g/g' d12.time 
gawk -F, '{print $4,$6,$8,$11}' d12.time
