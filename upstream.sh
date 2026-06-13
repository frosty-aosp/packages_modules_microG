#!/bin/bash

# be strict on failures
set -euo pipefail

echo "Fetching microg files"

get_microg_files() {
    local trg_name src_name src_url
    trg_name="${1}"
    src_name="${2}"
    # Check for file
    [[ -f "$(dirname "${BASH_SOURCE[0]}")"/"${trg_name}"/"${trg_name}".apk ]] && return
    # Latest tag
    src_url=$(curl --fail --silent --show-error https://api.github.com/repos/microg/GmsCore/releases/latest | grep -E "/${src_name}-[0-9]+.apk\"" | cut -d"\"" -f4)
    curl --fail --silent --show-error --location "${src_url}" --output "$(dirname "${BASH_SOURCE[0]}")"/"${trg_name}"/"${trg_name}".apk
}

get_fdroid_files() {
    local trg_name src_name
    trg_name="${1}"
    src_name="${2}"
    [[ -f "$(dirname "${BASH_SOURCE[0]}")"/"${trg_name}"/"${trg_name}".apk ]] && return
    curl --fail --silent --show-error https://f-droid.org/"${src_name}".apk --output "$(dirname "${BASH_SOURCE[0]}")"/"${trg_name}"/"${trg_name}".apk
}

# Drop apks older than a day
find "$(dirname "${BASH_SOURCE[0]}")"/ -name "*.apk" -ctime +1 -exec rm {} \;

get_microg_files GmsCore "com.google.android.gms"
get_microg_files FakeStore "com.android.vending"

get_fdroid_files FDroid F-Droid

set +euo pipefail

