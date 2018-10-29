#!/bin/bash

set -e

## CHANGE ME ##
# this should match manifest.yml
MANIFEST=manifest.yml
###############

## Cloud Foundry CLI setup ##
# Get the cloud foundry public key and add the repository
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

# Update the local package index, then install the cf CLI
sudo apt-get update
sudo apt-get install cf-cli

# Login to Cloud Foundry
cf api $CF_API #Use the cf api command to set the api endpoint
cf login -u $CF_USERNAME -p $CF_PASSWORD -o $CF_ORGANIZATION -s $CF_SPACE


# Push app
cf push -f $MANIFEST
cf apps

echo "DONE"