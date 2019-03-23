dname=$1 

cd $dname


grep "sec elapsed" *log >time.convergence
gawk '{print $4,$5}' time.convergence |gawk -F, '{if ($1 %10 ==0){print $2}}' >time.conv
#tail -1 $1.time.convergence |gawk '{print $1}'


endtime=$(grep "sec in all" *log | gawk '{print $6}')
#trueend=`gawk -F, '{print $5}' *time*.csv`
trueend=$(grep "Training Time:" *log | gawk '{print $4}')

offset=$(echo "$endtime - $trueend" | bc)
echo "endtime=$endtime, trueend=$trueend, offset=$offset"
echo $endtime >> time.conv

OFFSET=$offset
echo " " > time.conv.offset
for t in `cat time.conv`; do echo $t-$OFFSET | bc ; done >> time.conv.offset

sed -i 's/,//g' *auc*.csv

paste -d " " *auc*.csv time.conv.offset |tee convergence.csv
