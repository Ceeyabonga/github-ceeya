#!/usr/bin/env bash

# AWS_PROFILE="dev-test"
# if [ "$AWS_PROFILE" = "" ]; then
#   echo "No AWS_PROFILE set"
#   exit 1
# fi

# Get Region
for region in $(aws ec2 describe-regions --region eu-west-1 | jq -r .Regions[].RegionName); do

  echo "* Region ${region}"

  # Get ConfigurationRecorders
  recorder=$(aws configservice --region ${region} \
    describe-configuration-recorders \
    | jq -r .ConfigurationRecorders[0].name)
  if [ "${recorder}" = "null" ]; then
    echo "No ConfigurationRecorders found in ${region}" >> no-config-recorders.txt
    continue
  fi
  echo "in ${region} Found ConfigurationRecorder ${recorder}" >> config-recorders.txt

 # Delete ConfigurationRecorders
  echo "Deleting ConfigurationRecorders ${recorder}"
  aws configservice --region ${region} \
    stop-configuration-recorder --configuration-recorder-name ${recorder}
  aws configservice --region ${region} \
    delete-configuration-recorder --configuration-recorder-name ${recorder}

done