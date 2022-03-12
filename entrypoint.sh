#!/bin/sh

set -e

# performing validations.
if [ -z "$S3_BUCKET_NAME" ]; then
  echo "S3_BUCKET_NAME is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION is not set. Quitting."
  exit 1
fi

if ! aws s3api head-bucket --bucket "$S3_BUCKET_NAME" ; then
  echo "Invalid S3 Bucket Name. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  SOURCE_DIR="./";
fi


# s3 sync command to copy directory in local filesystem to an s3 bucket.
sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${S3_BUCKET_NAME}/${TARGET_DIR} \
              --region ${AWS_REGION} $*"