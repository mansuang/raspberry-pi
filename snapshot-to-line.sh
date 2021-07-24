#/bin/bash


dt=$(date '+%Y%m%d%H%M%S');

# Capture photo frame
sudo ffmpeg -y -i 'rtsp://{camera-user-name}:{camera-password}@{192.168.1.50-camera-ip}/cam/realmonitor?channel=1&subtype=00&authbasic=YWRtaW46TDI3NjkwOTU=' -vframes 1 image.jpg

# Upload to AWS S3
aws s3 cp image.jpg s3://{your-bucket-name}/images/${dt}.jpg --acl public-read

# Send notification to LINE
curl --location --request POST 'https://notify-api.line.me/api/notify' \
--header 'Authorization: Bearer {your-line-bearer-token}' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'message={เมล่อน}' \
--data-urlencode "imageFullsize=https://{your-bucket-name}.s3-ap-southeast-1.amazonaws.com/images/${dt}.jpg" \
--data-urlencode "imageThumbnail=https://{your-bucket-name}.s3-ap-southeast-1.amazonaws.com/images/${dt}.jpg"

# Set crontab for example
# 0       12      *       *       *       bash /home/pi/snapshort-to-line.sh
