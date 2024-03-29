#!/usr/bin/env sh
clear
cd "$(dirname $0)"

printf 'Boruto Downloader\n'
printf '==================\n\n'

if [ $# -eq 1 ]; then
  issue_start=$1
  issue_end=$1
elif [ $# -eq 2 ]; then
  issue_start=$1
  issue_end=$2
else
  printf 'Start from issue: '; read issue_start
  printf 'Last issue: '; read issue_end
  printf '\n'
fi

for issue in $(seq ${issue_start} ${issue_end}); do

    echo "Borto-${issue}"
    echo "-----------"

    # Get HTML which contains the links to the images
    issue_html=$(wget --quiet --output-document=- "https://boruto-manga.com/manga/boruto-chapter-${issue}/")

    issue=$(printf "%02d" ${issue})

    if ! echo "${issue_html}" | grep --fixed-strings --quiet 'img '; then
        printf "Issue not found\n\n"
        continue
    fi

    echo '1. create directory'
    mkdir --parent "boruto_${issue}"

    echo '2. download images'
    echo "${issue_html}" |
    	 grep --only-matching --extended-regexp '<img .*\.(jpg|png|webp)"' |
       grep --only-matching --extended-regexp 'http.*\.(jpg|png|webp)' |
    	xargs --max-lines --max-procs=20 wget --quiet --no-clobber --directory-prefix="boruto_${issue}"

    echo "3. generate PDF boruto_${issue}.pdf"
    convert $(ls "boruto_${issue}"/* -v | tr '\n' ' ') -auto-orient "boruto_${issue}.pdf"
    echo
done
