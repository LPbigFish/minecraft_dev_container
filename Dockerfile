FROM itzg/minecraft-server:java21-alpine

ENV FOLDER="plugins"

RUN apk update && apk --no-cache add udev

# Add the monitoring script
ADD plugin_watch.sh /usr/local/bin/watch-plugins.sh

# Make the script executable
RUN chmod +x /usr/local/bin/watch-plugins.sh

# Start the custom startup script
ENTRYPOINT [ "/usr/local/bin/watch-plugins.sh", "${FOLDER}"]
