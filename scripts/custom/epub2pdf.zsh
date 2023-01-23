epub2pdf() {
  for file in $@; do
    #  skip non .epub file
    [[ $file =~ .epub$ ]] || continue

    dist=$file.pdf
    # skip same name dist
    [[ -e $dist ]] && echo "Already exists: $dist" && continue

    # convert
    echo -n "Converting: $file"
    /Applications/calibre.app/Contents/MacOS/ebook-convert $file $dist &>/dev/null
    echo "\033[G\033[2KConverted: $dist"

  done
}
