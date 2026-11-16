#!/bin/bash

cd ~/homelab || exit

if [ ! -f .env ]; then
    echo "### Error ###: No master .env file found in ~/homelab/"
    exit 1
fi

for dir in */ ; do
    ln -sf ../.env "${dir}.env"
    echo ".env file created in ${dir}"
done

echo "### DONE ###: Every .env file has been created in each subdirectory"