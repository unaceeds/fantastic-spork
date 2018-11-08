#!/bin/bash

url=$1
delay=$2
wget -q -O old.html $url
while (true); do
  wget -q -O new.html $url
  if diff old.html new.html > /dev/null; then
    echo "no difference"
  else
    echo "got some difference"
    rm old.html
    mv new.html old.html
    md5=$(md5sum old.html | awk '{print $1}').html
    cp old.html $md5
    git add $md5
    git commit -m "new contents of $url"
    git push
  fi
  sleep $delay
done
