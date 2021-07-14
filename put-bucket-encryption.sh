# Check if bucket is SSE enabled and then encrypt using SSE AES256:
#!/bin/bash
#List all buckets and store names in a array.
arr=(`aws s3api list-buckets --query "Buckets[].Name" --output text`)
# Check the status before encryption:
for i in "${arr[@]}"
do
        echo "Check if SSE is enabled for bucket -> ${i}"
        aws s3api get-bucket-encryption --bucket ${i}  | jq -r .ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm

done

# Encrypt all buckets in your account:
for i in "${arr[@]}"
do
        echo "Encrypting bucket with SSE AES256 for -> ${i}"
        aws s3api put-bucket-encryption --bucket ${i}  --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

done
