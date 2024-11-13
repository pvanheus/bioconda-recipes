#!/bin/bash

mkdir -pv $PREFIX/bin
cp -rv clair3 models preprocess postprocess scripts shared $PREFIX/bin
cp clair3.py $PREFIX/bin/
cp run_clair3.sh $PREFIX/bin/
make CC=${GCC} CXX=${GXX}  PREFIX=${PREFIX}
cp  longphase libclair3* $PREFIX/bin

# fetch latest models
MODELS=$(curl https://raw.githubusercontent.com/nanoporetech/rerio/refs/heads/master/README.rst  |grep -A 20 'Clair3 models' | awk 'BEGIN {read=0; seen=0} ; seen && $1 ~ /^==/ { read = 0 } ; read && $1 ~ /^r/ { print $1 ; seen=1 } ; $1 == "Config" { read=1 } ')
for MODEL in $MODELS ; do 
	URL=https://raw.githubusercontent.com/nanoporetech/rerio/refs/heads/master/clair3_models/${MODEL}_model
	MODEL_URL=$(curl $URL)
	curl $MODEL_URL |tar -C $PREFIX/bin/models -zxf - 
done
	
