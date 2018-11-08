#!/bin/bash

url=$1
md5=history/$(echo -n "$url" | md5sum | awk '{print $1}').html
delay=$2
if [ ! -e $md5 ]; then
  wget -q -O $md5 $url
  git add $md5
  git commit -m "some new things"
  git push
fi
while (true); do
  wget -q -O new.html $url
  difference=$(diff -y --suppress-common-lines $md5 new.html)
  if [ $(echo $difference | wc -c) -gt 1 ]; then
    echo "got some difference"
    echo $difference
    rm $md5; mv new.html $md5
    git add $md5
    git commit -m "new contents of $url"
    git push
  else
    echo "no difference"
  fi
  sleep $delay
done
