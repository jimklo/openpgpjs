#!/bin/bash

SPIDERMONKEY=false

while getopts ":s" Option
# Initial declaration.
# c, s, and d are the flags expected.
# The : after flag 'c' shows it will have an option passed with it.
do
case $Option in
s ) SPIDERMONKEY=true ;;
esac
done
shift $(($OPTIND - 1))


echo "Setup..."
_src="src";
_spidermonkey="engines/spidermonkey"
_tmp="resources/openpgp.js.tmp";
_raw="resources/openpgp.js";
_min="resources/openpgp.min.js";
_compiler="resources/compiler.jar";
_majorVersion=".1"
:>"$_raw"
:>"$_min"


if [ $SPIDERMONKEY = true ]; then
    echo "Concatenating SpiderMonkey extras..."
    find "$_spidermonkey" -name "*.js" -exec cat "{}" >> "$_raw" \;
fi

echo "Concatenating..."
find "$_src" -name "*.js" -exec cat "{}" >> "$_tmp" \;
sed "s/OpenPGP.js VERSION/OpenPGP.js v$_majorVersion.$(date +%Y%m%d)/g" "$_tmp" > "$_raw";
rm "$_tmp";




echo "Minimizing..."
java -jar "$_compiler" --js "$_raw" --js_output_file "$_min"
