#!/bin/zsh
#
# Docker Update Check and Notification Script
#
# This script checks for updates in Docker containers using watchtower,
# and sends a notification via Apprise if updates are found. The notification
# includes the number of updated containers and the detailed output from watchtower.
#
# Make sure to set your Apprise notification service URL (APPRISE_URL) before running this script.
#

# Set your Apprise notification service URL
APPRISE_URL="https://apprise.url.here"

# Specify the watchtower image
WATCHTOWER_IMAGE="docker.io/containrrr/watchtower:latest"

# Function to check for updates and send notification
check_and_notify_updates() {
    local updated_containers

    # Function to check for updates and update containers
    check_and_update_containers() {
        echo "Checking for updates..."
        updated_containers=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock $WATCHTOWER_IMAGE --run-once 2>&1)
        echo "watchtower output: $updated_containers"
    }

    # Function to send notification using curl
    send_notification() {
        local title="$1"
        local body="$2"
        
        curl -k -X POST -F "title=$title" -F "body=$body" "$APPRISE_URL"
    }

    # Main execution
    check_and_update_containers

    # Extract the number of updated containers from the output
    num_updated_containers=$(echo "$updated_containers" | grep -oP 'Updated=\K\d+')

    # Check if there were updates
    if [ "$num_updated_containers" -gt 0 ]; then
        echo "Updates found. Sending notification..."
        send_notification "Docker updates - $num_updated_containers containers updated" "Watchtower output:\n$updated_containers"
    else
        echo "No updates found."
    fi
}

# Call the function
check_and_notify_updates
