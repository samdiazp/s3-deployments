# AWS CLI installation using Chocolatey
$env:AWS_ACCESS_KEY_ID = $env:AWS_ACCESS_KEY_ID
$env:AWS_SECRET_ACCESS_KEY = $env:AWS_SECRET_ACCESS_KEY
$PATH_FOLDER = $env:PATH_FOLDER
$AWS_DEFAULT_REGION = "us-east-1"

$S3_BUCKET = $env:S3_BUCKET


#Build process
Write-Host "Building the project..."
yarn --cwd $PATH_FOLDER build

# Sync the local build folder with the S3 bucket using the full path to aws executable
$FULL_PATH = Join-Path $PATH_FOLDER "build"
aws s3 sync $FULL_PATH s3://$S3_BUCKET --delete --acl public-read
aws s3api copy-object --copy-source "$S3_BUCKET/index.html" --bucket $S3_BUCKET --key index.html --metadata-directive REPLACE --cache-control "no-cache,max-age=0,must-revalidate" --content-type "text/html" --acl public-read


Write-Host "Deployment to S3 complete."
