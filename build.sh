AWS_KEY=
packer build -var aws_access_key=$(echo $AWS_ACCESS_KEY_ID) -var aws_secret_key=$(echo $AWS_SECRET_ACCESS_KEY) box.json