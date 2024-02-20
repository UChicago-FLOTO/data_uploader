DIRECTORY="${DIRECTORY:-/share/data/}"

# Create the config from passed in env
config_path=/root/.config/rclone/rclone.conf
mkdir -p /root/.config/rclone/
echo [target] >> $config_path
for json in $(echo $RCLONE_CONFIG_JSON | jq -c '. | to_entries | .[]'); do
	key=$(echo $json | jq -r .key)
	value=$(echo $json | jq -r .value)
	echo "$key = $value" >> $config_path
done

echo Creating remote data directory
rclone --no-check-certificate mkdir target:job-$FLOTO_JOB_UUID-data

while true; do
	if [ -d "$DIRECTORY" ]; then
		inotifywait --recursive -e modify,delete,create,move $DIRECTORY
		if [ $? -eq 0 ]; then
			echo Syncing to remote
			rclone --no-check-certificate sync $DIRECTORY target:job-$FLOTO_JOB_UUID-data/
		fi
	else
		echo $DIRECTORY does not exist. Waiting...
	fi 
	sleep 5
done
