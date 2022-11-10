#!/bin/bash

#Set Environment variables
instanceid=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
jobflowid=$(cat /mnt/var/lib/info/job-flow.json | jq -r ".jobFlowId")
pDNSName=`wget -q -O - http://169.254.169.254/latest/meta-data/local-hostname`
azone=`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone`
region=${azone/%?/}
#CLOUDWATCH_OPTS=$(--namespace EMRS/Job Flow Metrics --dimensions JobFlowId=$jobflowid)
AWSACCOUNTID=$(aws sts get-caller-identity | grep -i Account | cut -d':' -f2 | cut -d'"' -f2)
SNSTOPIC=$(echo "ACTLIsEMRIdle")

#Set Default AWS region
sudo aws configure set region $region
export EC2_REGION=$region

#Create Alarm
sudo aws cloudwatch put-metric-alarm --region $region --alarm-name EMRIdle-$jobflowid --period "300" --statistic "Average" --metric-name "AppsRunning" --namespace "AWS/ElasticMapReduce" --dimensions "Name=JobFlowId,Value=$jobflowid" --comparison-operator "LessThanThreshold" --treat-missing-data "missing" --datapoints-to-alarm "5" --evaluation-periods "5" --threshold "1" --alarm-actions arn:aws:sns:"$region":"$AWSACCOUNTID":"$SNSTOPIC"