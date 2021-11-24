#!/bin/sh
echo START!
if [ $? == 0 ]
then
  git clone https://github.com/nodejs/nodejs.org.git
  cd nodejs.org
  npm install
  npm start
fi