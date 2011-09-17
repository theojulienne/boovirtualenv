if [ "$VIRTUAL_ENV" == "" ]; then
	echo "Error: You need to run this inside a virtualenv."
	exit 1
fi

echo "Found your virtualenv: $VIRTUAL_ENV"

TMP_DIR=/tmp/$$.tmp

mkdir -p $TMP_DIR
cd $TMP_DIR

wget http://dist.codehaus.org/boo/distributions/boo-0.9.4.9.tar.gz
tar -zxvf boo-0.9.4.9.tar.gz
rm -rf $VIRTUAL_ENV/boo
rm -rf $VIRTUAL_ENV/boo-0.9.4.9
mv boo-0.9.4.9 $VIRTUAL_ENV/
ln -s $VIRTUAL_ENV/boo-0.9.4.9 $VIRTUAL_ENV/boo

cd
rm -rf $TMP_DIR
