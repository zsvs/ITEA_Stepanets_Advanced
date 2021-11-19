#!/bin/ash
mkdir 1
if [ $? == 0 ]
then
  cd /nodejs/nodejs.org
  npm install
  npm start
fi