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
#bucket=gs://mamecloud-functions/
#region=europe-west1
#zone=europe-west1-b

# Point to the GCP project
# If you need to authenticate, use "gcloud auth login"
gcloud config set account $(cat account.txt)
gcloud config set project $(cat project.txt)
#gcloud compute project-info add-metadata \
#    --metadata google-compute-default-region=$region,google-compute-default-zone=$zone

# Update functions
#cd functions && zip -r functions.zip . && mv functions.zip $base/static/
#cd $base

cd $base/functions/selectgame
function=SelectGame
echo "Deploying function $function from directory ${PWD##*/}"
gcloud functions deploy $function --runtime go113 --trigger-http --allow-unauthenticated --region=europe-west1

cd $base/functions/

cd $base



# Update bucket

#gsutil -m cp -r static/* gs://notbinary-signature-builder
#rm static/functions.zip

# Deploy functions
# TODO: deploy from a source repo?
#region="--region=europe-west1"
#options="--runtime=python37 --source=gs://notbinary-signature-builder/functions.zip --memory=128MB --trigger-http"
#gcloud functions deploy plain          ${region} ${options} --entry-point=plain
#gcloud functions deploy now-soon-later ${region} ${options} --entry-point=now_soon_later
#gcloud functions deploy with-strapline ${region} ${options} --entry-point=with_strapline
