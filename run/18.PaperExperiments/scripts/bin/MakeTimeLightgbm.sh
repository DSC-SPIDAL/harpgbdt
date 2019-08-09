dname=$1 

cd $dname

grep "seconds elapsed" *log >time.convergence
echo "" > time.conv
gawk '{print $3,$8}' time.convergence |gawk '{if ($2 %10 ==0){print $1}}' >>time.conv
#tail -1 $1.time.convergence |gawk '{print $1}'

paste -d " " *auc*.csv time.conv |tee convergence.csv


