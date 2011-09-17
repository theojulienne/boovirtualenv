if [ "$VIRTUAL_ENV" == "" ]; then
	echo "Error: You need to run this inside a virtualenv."
	exit 1
fi

echo "Found your virtualenv: $VIRTUAL_ENV"

BIN_DIR=$VIRTUAL_ENV/bin
BOO_DIR=$VIRTUAL_ENV/boo
GAC_DIR=$VIRTUAL_ENV/gac
NANT_DIR=$VIRTUAL_ENV/nant

make_runner()
{
	name="$1"
	real_path="$2"
	
	cat > $BIN_DIR/$name <<EOF
#!/bin/sh
app="mono"
if [ -x cli ]; then
	app="cli"
fi
env \$app \$MONO_OPTIONS $real_path "\$@"
EOF
	chmod +x $BIN_DIR/$name
}

make_gacutil()
{
	REAL_GACUTIL=`which -a gacutil | grep -v "$VIRTUAL_ENV" | head -n 1`
	
	cat > $BIN_DIR/gacutil <<EOF
#!/bin/sh

EXTRA_OPTIONS="-gacdir $GAC_DIR"

for arg in "\$@"
do
    if [ "\$arg" == "-gacdir" ]; then
		EXTRA_OPTIONS=""
	fi
done

if [[ "\$@" == "" || "\$@" == "-?" ]]; then
	EXTRA_OPTIONS=""
fi

$REAL_GACUTIL \$@ \$EXTRA_OPTIONS
EOF
	chmod +x $BIN_DIR/gacutil
}

postactivate=$VIRTUAL_ENV/bin/postactivate

# make the virtual GAC
grep -v "MONO_GAC_PREFIX" $postactivate > $postactivate.tmp
echo "export MONO_GAC_PREFIX=\"$GAC_DIR:\$MONO_GAC_PREFIX\"" >> $postactivate.tmp
rm $postactivate
mv $postactivate.tmp $postactivate
chmod +x $postactivate
mkdir -p $GAC_DIR/lib/mono/gac

# link in boo runners
rm -rf $BIN_DIR/boo[c,i,ish]
make_runner "booc" "$BOO_DIR/bin/booc.exe"
make_runner "booi" "$BOO_DIR/bin/booi.exe"
make_runner "booish" "$BOO_DIR/bin/booish.exe"
make_runner "nant" "$NANT_DIR/bin/NAnt.exe"
make_gacutil

# use our patched gacutil to add in all our required entries
for entry in $BOO_DIR/bin/Boo.Lang*.dll; do
	gacutil -i $entry
done

# add the nant task
ln -s $BOO_DIR/bin/Boo.NAnt.Tasks.dll $NANT_DIR/bin/