if [ "$VIRTUAL_ENV" == "" ]; then
	echo "Error: You need to run this inside a virtualenv."
	exit 1
fi

echo "Found your virtualenv: $VIRTUAL_ENV"

TMP_DIR=/tmp/$$.tmp

mkdir -p $TMP_DIR
cd $TMP_DIR

wget "http://downloads.sourceforge.net/project/nant/nant/0.91-alpha2/nant-0.91-alpha2-bin.tar.gz?r=&ts=1316236943&use_mirror=waix" -O nant.tar.gz
tar -zxvf nant.tar.gz
rm -rf $VIRTUAL_ENV/nant
rm -rf $VIRTUAL_ENV/nant-0.91-alpha2
mv nant-0.91-alpha2 $VIRTUAL_ENV/
ln -s $VIRTUAL_ENV/nant-0.91-alpha2 $VIRTUAL_ENV/nant

cd
rm -rf $TMP_DIR