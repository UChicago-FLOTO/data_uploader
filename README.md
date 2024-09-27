# Data Uploader

This is the source to a [FLOTO service](https://github.com/UChicago-FLOTO/docs/blob/master/user/application_user.md)
that will automatically upload FLOTO data to a configurable remote source. It
does this by watching a directory for changes, and then using
[rclone](https://rclone.org/) to sync the data.

## Configuration
- `RCLONE_CONFIG_JSON` environment variable **must** be set to a valid rclone
    config JSON dump for a single source. If you have configured rclone on your personal computer,
    you can get this by running `rclone config dump`. A simple way to get this
    formatted correctly is to run `rclone config dump | jq -c .my_source` where
    `my_source` is replaced by the name of your rclone remote. You can then copy
    and paste this into the environment variable for your FLOTO application or job.
- `DIRECTORY` environment variable is the directory to watch for data in. By
    default, this is `/share/data`, as `/share` is mounted across all FLOTO
    containers within the same application.

- `TARGET_BUCKET` environment variable sets the name of the bucket to upload to. It will default to `job-$SHORT_JOB_ID-device-$SHORT_DEVICE_ID-data`,
    where `SHORT_JOB_ID` will be set to the first 8 chars of the UUID of your FLOTO job,
    and `SHORT_DEVICE_ID` will be set to the first 8 chars of the UUID of the
    device.

## Usage

To use this image in your own service see [packages](https://github.com/UChicago-FLOTO/data_uploader/pkgs/container/data_uploader) for versioned tags. For the latest image reference, you can use `ghcr.io/uchicago-floto/data_uploader:latest`.

Once data changes are detected in `$DIRECTORY`, files are synced to your remote source in a bucket named $TARGET_BUCKET, using the rclone remote configuration passed via $RCLONE_CONFIG_JSON
