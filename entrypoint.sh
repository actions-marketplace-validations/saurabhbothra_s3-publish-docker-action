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

mkdir -p ~/.aws
touch ~/.aws/config

echo "[profile s3-publish-action]
region = ${AWS_REGION}
role = ${AWS_ROLE}
account = ${AWS_ACCOUNT_ID}" > ~/.aws/config

aws configure --profile s3-publish-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${S3_BUCKET_NAME}/${TARGET_DIR} \
              --profile s3-publish-action \
              $*"

aws configure --profile s3-publish-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF

rm -rf ~/.aws