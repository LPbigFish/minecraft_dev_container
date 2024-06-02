#!/bin/bash
PLUGIN_DIR="/data/$1"  # Path to the plugins directory within the container
INTERVAL=5  # Check every 10 seconds

echo "starting server..."

/start &

echo "Starting to watch for .jar files in $PLUGIN_DIR..."

# Initialize the last modification time to 0
last_mtime=0
number_of_files=0

while true; do
  # Get the latest modification time in PLUGIN_DIR
  latest_mtime=$(find "$PLUGIN_DIR" -name '*.jar' -printf '%T@\n' | sort -nr | head -1)
  new_nof=$(find "$PLUGIN_DIR" -name '*.jar' | wc -l)

  # If the latest modification time is greater than the last one, a file has changed
  if [[ "$latest_mtime" > "$last_mtime" || "$number_of_files" != "$new_nof" ]]; then
    echo "Detected a change. Reloading plugins..."
    mc-send-to-console reload confirm
    last_mtime=$latest_mtime
    number_of_files=$new_nof
  fi

  # Wait for the interval before checking again
  sleep $INTERVAL
done