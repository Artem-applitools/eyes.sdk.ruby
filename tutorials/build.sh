#!/bin/bash

ls
cp -a ../pkg/gems/. ./gems
docker build -t chrome_ruby .
docker build -t ruby_selenium_basic -f selenium_basic/Dockerfile .
docker build -t ruby_selenium_ufg -f selenium_ufg/Dockerfile .
rm -r gems
