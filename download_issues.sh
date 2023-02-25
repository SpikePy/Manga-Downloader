#!/usr/bin/env sh
clear
cd "$(dirname $0)"

echo 'Berserk Downloader'
echo '=================='
echo

echo -n 'Start from issue: '; read issue_start
echo -n 'Last issue: '; read issue_end
echo ''

for issue in $(seq ${issue_start} ${issue_end}); do

    # prefix/zero pad issue number
    issue=$(printf "%03d" ${issue})

    echo "Berserk-${issue}"
    echo "-----------"
    
    # Get HTML which contains the links to the images
    issue_html=$(wget --quiet --output-document=- "https://readberserk.com/chapter/berserk-chapter-${issue}/")

    if ! echo "${issue_html}" | grep --fixed-strings --quiet 'img class'; then
        echo "Issue not found"
    fi

    echo '1. create directory'
    mkdir --parent "${issue}"

    echo '2. download images'
    echo "${issue_html}" |
    	grep --fixed-strings 'img class' | 
    	grep --fixed-strings 'jpg' | 
    	cut --delimiter='"' --fields=4 | 
    	xargs --max-lines --max-procs=20 wget --quiet --no-clobber --directory-prefix="${issue}"

    echo "3. generate PDF berserk_${issue}.pdf"
    convert $(ls "${issue}"/* -v | tr '\n' ' ') -auto-orient "berserk_${issue}.pdf"
    echo ''
done
