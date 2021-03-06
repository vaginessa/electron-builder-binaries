#!/usr/bin/env bash

version=`cat Squirrel.Windows/version.txt`
archiveFileName=Squirrel.Windows-$version.7z
archiveFile=out/$archiveFileName
rm -f $archiveFile

cd Squirrel.Windows
7za a -m0=lzma2 -mx=9 -mfb=64 -md=64m -ms=on ../$archiveFile .
cd ..

if [ -z "$BT_ACCOUNT" ] ; then
  SEC=`security find-generic-password -l BINTRAY_API_KEY -g 2>&1`
  BT_ACCOUNT=`echo "$SEC" | grep "acct" | cut -d \" -f 4`
  BT_API_KEY=`echo "$SEC" | grep "password" | cut -d \" -f 2`
fi

curl --progress-bar -T $archiveFile -u${BT_ACCOUNT}:${BT_API_KEY} "https://api.bintray.com/content/electron-userland/bin/Squirrel.Windows/$version/$archiveFileName?override=0&publish=1" > out/result
result=`cat out/result`
if [ "$result" != '{"message":"success"}' ]; then
  >&2 echo "$result"
  exit 1
fi