if [ -z $_gbtproject_ ]; then 
    echo 'init the env by run "source gbt-test/bin/init_env.sh" first'
    exit 0
fi

echo "init tutorial..."

echo "make a directory: tutorial"
mkdir -p tutorial
cd tutorial

echo "copy files to tutorial"
cp -r $_gbtproject_/run/19.Tutorial/* .

echo "done!"
