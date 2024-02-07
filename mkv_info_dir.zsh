# Function: mkv_info_all
# Usage: mkv_info_all
# Description: Displays detailed information about tracks in Matroska (MKV) files in the current directory.
# Dependencies: jq (JSON processor), mkvmerge (MKV manipulation tool)
# Installation: Ensure jq and mkvmerge are installed. On Debian-based systems, use:
#   sudo apt-get install jq mkvtoolnix
# Author: Jarek Krochmalski

function mkv_info_all() {
    # Check if mkvmerge and jq are installed
    if ! command -v mkvmerge &> /dev/null || ! command -v jq &> /dev/null; then
        echo "Error: mkvmerge and jq are required for this function. Please install mkvtoolnix and jq."
        return 1
    fi

    # Iterate over all MKV files in the current directory
    for mkv_file in *.mkv; do
        # Display information about tracks for each file
        echo "Tracks information for $mkv_file:"
        mkvmerge -J "$mkv_file" | jq '.tracks[] | "\(.id) \(.type) \(.codec) \(.properties.language) \(.properties.track_name)"'
        echo "--------------------------------------------"
    done
}
