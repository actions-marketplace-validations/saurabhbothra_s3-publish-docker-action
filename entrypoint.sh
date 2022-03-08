#!/bin/sh

set -e

if [ -z "$S3_BUCKET_NAME" ]; then
  echo "S3_BUCKET_NAME is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ROLE" ]; then
  echo "AWS_ROLE is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCOUNT_ID" ]; then
  echo "AWS_ACCOUNT_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SESSION_TOKEN" ]; then
  echo "AWS_SESSION_TOKEN is not set. Quitting."
  exit 1
fi

mkdir -p ~/.aws
touch ~/.aws/config
touch ~/.aws/credentials

echo "[profile s3-publish-action]
region = ${AWS_REGION}
role = ${AWS_ROLE}
account = ${AWS_ACCOUNT_ID}" > ~/.aws/config

echo "[s3-publish-action]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
aws_session_token = ${AWS_SESSION_TOKEN}" > ~/.aws/credentials


sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${S3_BUCKET_NAME}/${TARGET_DIR} \
              --profile s3-publish-action \
              $*"
rm -rf ~/.aws