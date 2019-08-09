prefix='$1'

echo "==============lightgbm-d8================="
ls SpeedUp-lightgbm-higgs-*d8*/*.csv |xargs gawk -F, '{print $1, $3}'
echo "==============lightgbm-d12================="
ls SpeedUp-lightgbm-higgs-*d12*/*.csv |xargs gawk -F, '{print $1, $3}'


echo "==============xgb-d8================="
ls SpeedUp-xgb-latest-higgs-n10-d8*/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============xgb-d12================="
ls SpeedUp-xgb-latest-higgs-n10-d12*/*.csv | xargs gawk -F, '{print $1, $5}'


echo "==============dp-d8================="
ls SpeedUp-xgbo*-d8*-dp/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============dp-d12================="
ls SpeedUp-xgbo*-d12*-dp/*.csv | xargs gawk -F, '{print $1, $5}'


echo "==============mp-d8================="
ls SpeedUp-xgbo*-d8*-mp/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============mp-d12================="
ls SpeedUp-xgbo*-d12*-mp/*.csv | xargs gawk -F, '{print $1, $5}'



echo "==============async-d8================="
ls SpeedUp-xgbo*-d8*-async/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============async-d12================="
ls SpeedUp-xgbo*-d12*-async/*.csv | xargs gawk -F, '{print $1, $5}'


echo "==============asyncfix-d8================="
ls SpeedUp-xgbo*-d8*-async-fix/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============asyncfix-d12================="
ls SpeedUp-xgbo*-d12*-async-fix/*.csv | xargs gawk -F, '{print $1, $5}'

echo "==============sync-d8================="
ls SpeedUp-xgbo*-d8*-sync/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============syncfix-d12================="
ls SpeedUp-xgbo*-d12*-sync-fix/*.csv | xargs gawk -F, '{print $1, $5}'

echo "==============syncfix-d8================="
ls SpeedUp-xgbo*-d8*-sync-fix/*.csv | xargs gawk -F, '{print $1, $5}'
echo "==============sync-d12================="
ls SpeedUp-xgbo*-d12*-sync/*.csv | xargs gawk -F, '{print $1, $5}'
