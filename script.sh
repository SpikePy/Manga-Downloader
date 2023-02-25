#!/usr/bin/env sh
clear

cat << EOF
Berserk Downloader
==================

EOF

if [ $# -eq 1 ]; then
    issue_start=$1
    issue_end=$1
elif [ $# -eq 2 ]; then
    issue_start=$1
    issue_end=$2
else
  echo 'This script needs either 1 argument (the number of the issue you want to download) or 2 arguments (the range of issues you want to download)'
    exit 1
fi

for issue in $(seq ${issue_start} ${issue_end}); do

    issue=$(printf "%03d" ${issue})

    echo "Berserk ${issue}"
    echo "-----------"

    issue_html=$(wget --quiet --output-document=- "https://readberserk.com/chapter/berserk-chapter-${issue}/")

    if ! echo "${issue_html}" | grep --fixed-strings --quiet 'img class'; then
        echo "Issue not found"
        exit 1
    fi

    echo '1. create directory'
    mkdir --parent "${issue}"

    echo '2. download images'
    issue_html=$(wget --quiet --output-document=- "https://readberserk.com/chapter/berserk-chapter-${issue}/")

    echo "${issue_html}" | grep --fixed-strings 'img class' | grep --fixed-strings 'jpg' | cut --delimiter='"' --fields=4 | tr '\n' ' ' | xargs  wget --quiet --no-clobber --directory-prefix="${issue}"

    echo "3. generate PDF berserk_${issue}.pdf"
    convert $(ls "${issue}"/* -v | tr '\n' ' ') -auto-orient "berserk_${issue}.pdf"

    echo ''
done
