epub2pdf() {
  for file in $@; do
    #  skip non .epub file
    [[ $file =~ \.(epub|mobi|azw3)$ ]] || continue

    dist=$file.pdf
    # skip same name dist
    [[ -e $dist ]] && echo "Already exists: $dist" && continue

    # convert
    echo -n "Converting: $file"
    ebook-convert $file $dist &>/dev/null
    echo "\033[G\033[2KConverted: $dist"

  done
}

pdf2epub() {
  for file in $@; do
    #  skip non .epub file
    [[ $file =~ .pdf$ ]] || continue

    dist=$file.epub
    # skip same name dist
    [[ -e $dist ]] && echo "Already exists: $dist" && continue

    # convert
    echo -n "Converting: $file"
    ebook-convert $file $dist &>/dev/null
    echo "\033[G\033[2KConverted: $dist"

  done
}
