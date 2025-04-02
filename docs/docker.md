# Using a Docker container
The docker container that is created is meant to be used interactively. 

```
docker build -t cloudmapper .
```

Cloudmapper needs to make IAM calls and cannot use session credentials for collection, so you cannot use the aws-vault server if you want to collect data, and must pass role credentials in directly or configure aws credentials manually inside the container. *The following code exposes your raw credentials inside the container.* 

```
(                                                              
    export $(aws-vault exec YOUR_PROFILE --no-session -- env | grep ^AWS | xargs) && \ 
    docker run -ti \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        -p 8000:8000 \
        cloudmapper /bin/bash
)
```

This will drop you into the container. Run `aws sts get-caller-identity` to confirm this was setup correctly. Cloudmapper demo data is not copied into the docker container so you will need to collect live data from your system. Note docker defaults may limit the memory available to your container. For example on Mac OS the default is 2GB which may not be enough to generate the report on a medium sized account.

```
python cloudmapper.py configure add-account --config-file config.json --name YOUR_ACCOUNT --id YOUR_ACCOUNT_NUMBER
python cloudmapper.py collect --account YOUR_ACCOUNT
python cloudmapper.py report --account YOUR_ACCOUNT
python cloudmapper.py prepare --account YOUR_ACCOUNT
python cloudmapper.py webserver --public
```

You should then be able to view the report by visiting http://127.0.0.1:8000/account-data/report.html

