#!/usr/bin/env bash

# Check setup
if [ ! -f "account.txt" ]; then
    echo "Please create a file called account.txt, containing your GCP login email."
    exit 1
fi
if [ ! -f "project.txt" ]; then
    echo "Please create a file called project.txt, containing your GCP project ID."
    exit 1
fi

# Variables
base=$PWD
bucket=gs://mamecloud-functions/
region=europe-west1
zone=europe-west1-b

# Point to the GCP project
# If you need to authenticate, use "gcloud auth login"
gcloud config set account $(cat account.txt)
gcloud config set project $(cat project.txt)
gcloud compute project-info add-metadata \
    --metadata google-compute-default-region=$region,google-compute-default-zone=$zone

# Create resources
gcloud pubsub topics create game-request
gcloud pubsub subscriptions create arcade --topic game-request --expiration-period never

# Manual steps
echo "***"
echo "* Please create an API key with PubSub permission via the GCP console here: https://console.cloud.google.com/apis/credentials?project=$(cat project.txt)"
echo "***"
