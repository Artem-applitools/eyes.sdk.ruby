#!/bin/bash

echo $(pwd)
ls
cp -a ./pkg/gems/. ./tutorials/gems
docker build -t ruby_selenium_basic -f tutorials/selenium_basic/Dockerfile.travis .
docker build -t ruby_selenium_ufg -f tutorials/selenium_ufg/Dockerfile.travis .
rm -r ./tutorials/gems
