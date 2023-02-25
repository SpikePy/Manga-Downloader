#!/usr/bin/env sh
clear
cd "$(dirname $0)"

cat << EOF
Berserk Downloader
==================

EOF

echo -n 'Start from issue: '
read issue_start
echo -n 'Last issue: '
read issue_end
echo ''

for issue in $(seq ${issue_start} ${issue_end}); do

    # prefix/zero pad issue number
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
