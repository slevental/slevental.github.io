#!/bin/bash

increment_version() {
 local v=$1
 if [ -z $2 ]; then
    local rgx='^((?:[0-9]+\.)*)([0-9]+)($)'
 else
    local rgx='^((?:[0-9]+\.){'$(($2-1))'})([0-9]+)(\.|$)'
    for (( p=`grep -o "\."<<<".$v"|wc -l`; p<$2; p++)); do
       v+=.0; done; fi
 val=`echo -e "$v" | perl -pe 's/^.*'$rgx'.*$/$2/'`
 echo "$v" | perl -pe s/$rgx.*$'/${1}'`printf %0${#val}s $(($val+1))`/
}

echo $(increment_version `cat ./Version`) > ./Version

version=`cat Version`

docker run --rm \
           -v "$(pwd):/src" \
           -w /src \
           ruby:2.3 \
           sh -c 'bundle install --path vendor/bundle && exec jekyll build'

docker build -t levental.io/blog .

docker tag levental.io/blog gcr.io/levental-io/blog:$version
