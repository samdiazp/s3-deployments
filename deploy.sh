#!/bin/bash
# Set your AWS credentials and region
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
PATH_FOLDER="$PATH_FOLDER"

# Set your S3 bucket name and the local build folder
S3_BUCKET="$S3_BUCKET"
AWS_DEFAULT_REGION="us-east-1

# Build process
echo "Building the project..."
yarn --cwd "$PATH_FOLDER" build 

# Sync the local build folder with the specified folder in the S3 bucket
FULL_PATH="$PATH_FOLDER/build"

aws s3 sync "$FULL_PATH" "s3://$S3_BUCKET" --delete --acl public-read
aws s3api copy-object --copy-source ${S3_BUCKET}/index.html --bucket ${S3_BUCKET} --key index.html --metadata-directive REPLACE --cache-control "no-cache,max-age=0,must-revalidate" --content-type "text/html"


echo "Deployment completed."