#!/bin/bash

ls
cp -a ./pkg/gems/. ./tutorials/gems
docker build -t chrome_ruby -f tutorials/Dockerfile.
docker build -t ruby_selenium_basic -f tutorials/selenium_basic/Dockerfile .
docker build -t ruby_selenium_ufg -f tutorials/selenium_ufg/Dockerfile .
rm -r ./tutorials/gems
