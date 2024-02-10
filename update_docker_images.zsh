#!/bin/zsh

# Set your Apprise notification service URL
APPRISE_URL="https://apprise.url.here"

# Function to check for updates and send notification
update_images() {
    local updated_containers

    # Function to check for updates and update containers
    check_and_update_containers() {
        echo "Checking for updates..."
        updated_containers=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock docker.io/containrrr/watchtower:latest --run-once)
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
    num_updated_containers=$(echo "$updated_containers" | grep -o "Updated=[0-9]*" | awk -F= '{print $2}')

    # Check if there were updates
    if [ "$num_updated_containers" -gt 0 ]; then
        echo "Updates found. Sending notification..."
        send_notification "Docker updates - $num_updated_containers containers updated" "Watchtower output:\n$updated_containers"
    else
        echo "No updates found."
    fi
}

# Call the function
update_images
