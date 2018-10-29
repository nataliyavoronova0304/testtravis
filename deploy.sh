#!/bin/bash

set -e

## CHANGE ME ##
# this should match manifest.yml
MANIFEST=manifest.yml
###############

unamestr=`uname`


## Cloud Foundry CLI setup ##
if ! hash cf 2>/dev/null; then
  echo "Installing Cloud Foundry CLI..."
  if [[ "$unamestr" == 'Darwin' ]]; then
    brew tap cloudfoundry/tap
    brew install cf-cli
  else
    mkdir -p tmp
    PATH=$PWD/tmp:$PATH
    curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx -C tmp
  fi
fi

if [ -n $CF_USERNAME ] && [ -n $CF_PASSWORD ]; then
  cf api $CF_API
  cf login -u $CF_USERNAME -p $CF_PASSWORD
fi
cf target -o $CF_ORGANIZATION -s $CF_SPACE
#############################


platform='linux'
if [[ "$unamestr" == 'Darwin' ]]; then
  platform='darwin'
fi


## manifest checking ##
if ! (cf plugins | grep -q antifreeze); then
  echo "Installing antifreeze..."
  cf install-plugin -f "https://github.com/odlp/antifreeze/releases/download/v0.3.0/antifreeze-$platform"
fi


## deployment ##
if ! (cf plugins | grep -q autopilot); then
  echo "Installing autopilot..."
  cf install-plugin -f "https://github.com/contraband/autopilot/releases/download/0.0.3/autopilot-$platform"
fi

echo "Deploying..."
cf push -f $MANIFEST
cf apps
################

echo "DONE"