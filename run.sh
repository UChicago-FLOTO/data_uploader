#!/bin/bash

DIRECTORY="${DIRECTORY:-/share/data/}"
SHORT_JOB_UUID=${FLOTO_JOB_UUID:0:8}
SHORT_DEV_UUID=${FLOTO_DEVICE_UUID:0:8}
TARGET_BUCKET="${TARGET_BUCKET:-job-$SHORT_JOB_UUID-device-${SHORT_DEV_UUID}-data}"

# Create the config from passed in env
config_path=/root/.config/rclone/rclone.conf
mkdir -p /root/.config/rclone/
echo [target] >> $config_path
for json in $(echo $RCLONE_CONFIG_JSON | jq -c '. | to_entries | .[]'); do
	key=$(echo $json | jq -r .key)
	value=$(echo $json | jq -r .value)
	echo "$key = $value" >> $config_path
done

echo Creating remote data directory $TARGET_BUCKET
rclone --no-check-certificate mkdir target:$TARGET_BUCKET

while true; do
	if [ -d "$DIRECTORY" ]; then
		inotifywait --recursive -e modify,delete,create,move $DIRECTORY
		if [ $? -eq 0 ]; then
			echo Syncing to remote
			rclone --no-check-certificate sync $DIRECTORY target:$TARGET_BUCKET
		fi
	else
		echo $DIRECTORY does not exist. Waiting...
	fi 
	sleep 5
done
