#!/usr/bin/env bash

NVM_DIR="$HOME/.nvm"
if [ -f "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

type nvm &> /dev/null
if [ $? -eq 1 ] ; then
  echo "Installing NVM"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
  [ -s "$NVM_DIR/nvm.sh"  ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  nvm install 5.0
fi

type "togeojson" &> /dev/null ;
if [ $? -eq 1 ]; then
  echo "Installing togeojson"
  npm i -g togeojson
fi

type "geojson-merge" &> /dev/null ;
if [ $? -eq 1 ] ; then
  echo "Installing geojson-merge"
  npm i -g geojson-merge
fi

tmp_dir="tmp"
mkdir -p $tmp_dir
files=()

echo -n "Converting files to json"
args=("$@")
in_files=("${args[@]:0:${#args[@]}-1}")
out_file=${args[-1]}
for f in $in_files; do
  echo -n "."
  files=("${files[@]}" "$tmp_dir/$(basename $f).json")
  togeojson "$f" > "${files[-1]}"
done
echo

echo "Merging json"
geojson-merge ${files[@]} > "$2"

rm -rf $tmp_dir

echo "done"


