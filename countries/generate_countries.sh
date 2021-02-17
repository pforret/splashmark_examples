#!/usr/bin/env bash

countries_url="https://gist.githubusercontent.com/kalinchernev/486393efcca01623b18d/raw/daa24c9fea66afb7d68f8d69f0c4b8eeb9406e83/countries"
countries_file="countries.txt"
output_md="countries.md"
[[ ! -f "$countries_file" ]] && curl -s "$countries_url" > "$countries_file"
cat > "$output_md" <<END
# Splashmark Countries

These photos were all generated by the [pforret/splashmark](https://github.com/pforret/splashmark) CLI tool.

* using the Unsplash API to find and download the most popular (most downloaded) photo **for each country in the world**
* resize and crop to a square 800x800 format (Instagram size)
* add the country's name as a big title
* automatically add the Unsplash URL and photographer attribution as printed text, but also in the EXIF/IPTC metadata

This is what the command line looks like for Cape Verde


    splashmark -q -w 800 -c 800 -z 160 -i "Cape Verde" -r "FFFFFFCC" -e dark search CapeVerde_ig.jpg "Cape+Verde"


END
  cat "$countries_file" \
| while read -r country ; do
    slug="${country//[^a-zA-Z]/}"
    search="${country// /+}"
    title="${country// /\n}"
    img_name="${slug}_ig.jpg"
    if [[ ! -f "$img_name" ]] ; then
      echo "-- Download $country" >&2
      splashmark -w 800 -c 800 -z 130 -i "$title" -r "FFFFFFCC" -e dark search "$img_name" "$search"
    fi
    if [[ -f "$img_name" ]] ; then
      {
      echo "## $country"
      echo "![$country]($img_name)"
      echo " "
      } >> "$output_md"
    else
      {
      echo "## $country"
      echo "(nothing found)"
      echo " "
      } >> "$output_md"
    fi

  done