cd c:\;
mkdir temp;
cd temp;
Read-S3Object -BucketName ct-ire-poc1-tenable-agent -Key windows/NessusAgent-10.1.4-x64.msi -File NessusAgent-10.1.4-x64.msi;
Start-Process msiexec.exe -Wait -ArgumentList '/I NessusAgent-10.1.4-x64.msi /quiet';
cd "C:\Program Files\Tenable\Nessus Agent";
.\"nessuscli.exe" agent link --key=7f26d3482e7afa2a3147259e3a8f5bceab19a62d4a693ea9e1114d0edd483297 --host=sensor.cloud.tenable.com --port=443
