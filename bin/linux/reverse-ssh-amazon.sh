#!/bin/bash 

echo "Starting remote ssh port redirect from amazon.crespo.in:1234 to localhost:22"
until `ssh -p 23 ubuntu@amazon.crespo.in -i ~/.ssh/fernando_ec2.pem -R 1234:localhost:22 -N`; do
    echo "Restarting remote ssh port redirect from nas.crepo.in:1234 to localhost:22"
    sleep 1
done
