FROM ubuntu

RUN apt update && apt install -y jq inotify-tools wget unzip

RUN wget https://downloads.rclone.org/v1.65.2/rclone-v1.65.2-linux-arm64.zip
RUN unzip rclone-v1.65.2-linux-arm64.zip
RUN cp rclone-v1.65.2-linux-arm64/rclone /usr/bin/

COPY run.sh .

CMD bash run.sh
