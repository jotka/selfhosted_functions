# Author: Jarek Krochmalski

# Function: mkv_conv
# Usage: mkv_conv <mkv_input>
# Description: Displays detailed information about tracks in a Matroska (MKV) file,
#   prompts the user for audio and subtitle tracks to keep, and then converts the file.
# Dependencies: jq (JSON processor), mkvmerge (MKV manipulation tool)
# Installation: Ensure jq and mkvmerge are installed. On Debian-based systems, use:
#   sudo apt-get install jq mkvtoolnix

function mkv_conv() {
  echo "            _                               "
  echo "           | |                              "
  echo "  _ __ ___ | | ____   _____ ___  _ ____   __"
  echo " | '_ \` _ \| |/ /\ \ / / __/ _ \| '_ \ \ / /"
  echo " | | | | | |   <  \ V / (_| (_) | | | \ V / "
  echo " |_| |_| |_|_|\_\  \_/ \___\___/|_| |_|\_/  "
  echo

    if [[ -z "$1" ]]; then
        echo "Usage: mkv_conv <mkv_input>"
        return 1
    fi

    local mkv_input="$1"

    # Check if mkvmerge and jq are installed
    if ! command -v mkvmerge &> /dev/null || ! command -v jq &> /dev/null; then
        echo "Error: mkvmerge and jq are required for this function. Please install mkvtoolnix and jq."
        return 1
    fi

    # Check if the input file exists
    if [[ ! -e "$mkv_input" ]]; then
        echo "Error: Input file '$mkv_input' not found."
        return 1
    fi

    # Display information about tracks
    echo "Tracks information for $mkv_input:"
    mkvmerge -J "$mkv_input" | jq '.tracks[] | "\(.id) \(.type) \(.codec) \(.properties.language) \(.properties.track_name)"'

    # Prompt the user for audio and subtitle tracks to keep
    echo -n "Enter audio tracks you want to keep (comma-separated, e.g., 1,2): "
    read audio_tracks
    echo -n "Enter subtitle tracks you want to keep (comma-separated, e.g., 3,4): "
    read subtitle_tracks

    # Create a temporary output file
    local tmp_output="${mkv_input}_converted.tmp.mkv"

    # Perform the conversion
    mkvmerge -o "$tmp_output" --audio-tracks "$audio_tracks" --subtitle-tracks "$subtitle_tracks" "$mkv_input"

    # Check if mkvmerge was successful
    if [[ $? -eq 0 ]]; then
        echo "Conversion completed. Original file replaced: $mkv_input"
    else
        echo "Error: Conversion failed. Please check the input file and try again."
        return 1
    fi

    # Rename the temporary file to the original file
    mv "$tmp_output" "$mkv_input"
}
