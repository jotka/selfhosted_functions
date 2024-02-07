# Usage: mkv_info <INPUT>
# Description: Displays detailed information about tracks in a Matroska (MKV) file.
# Dependencies: jq (JSON processor), mkvmerge (MKV manipulation tool)
# Installation: Ensure jq and mkvmerge are installed. On Debian-based systems, use:
#   sudo apt-get install jq mkvtoolnix
function mkv_info() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkv_info <INPUT>"
        return 1
    fi

    local input="$1"
    mkvmerge -J "$input" | jq '.tracks[] | "\(.id) \(.type) \(.codec) \(.properties.language) \(.properties.track_name)"'
}
