cd c:\;
mkdir temp;
cd temp;
Read-S3Object -BucketName <bucket_name> -Key windows/NessusAgent-10.1.4-x64.msi -File NessusAgent-10.1.4-x64.msi;
Start-Process msiexec.exe -Wait -ArgumentList '/I NessusAgent-10.1.4-x64.msi /quiet';
cd "C:\Program Files\Tenable\Nessus Agent";
.\"nessuscli.exe" agent link --key=<your_key> --host=<your_host> --port=443
