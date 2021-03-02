#!/bin/bash

if [ ! -e "Gemfile.lock" ]; then
       bundle install
fi

ruby -W0 bin/main.rb