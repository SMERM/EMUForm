#!/bin/sh

if [ $TRAVIS_OS_NAME = 'linux' ]
then
  sudo apt-get update -qq
  sudo apt-get install -y libmagic-dev
  exit $?
fi

if [ $TRAVIS_OS_NAME = 'osx' ]
then
  sudo brew update
  sudo brew install libmagic
  exit $?
fi

exit 0
