#!/bin/bash
# Script to create an S3 bucket and update all terraform.tf files in infra with the bucket name
# chmod +x init/provision.sh
BUCKET=demo-data-platform-terraform-state
echo "Creating S3 bucket: ${BUCKET}..."
aws s3api create-bucket --bucket $BUCKET --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1

echo "Updating all terraform.tf files in infra/ with the bucket name..."
find ../infra -type f -name 'terraform.tf' | while read -r tf_file; do
  if grep -q 'bucket' "$tf_file"; then
    sed -i '' "s/bucket *= *.*/bucket = \"$BUCKET\"/" "$tf_file"
    echo "Updated $tf_file"
  fi
done

echo "Done."
