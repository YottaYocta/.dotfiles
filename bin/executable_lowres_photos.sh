#!/bin/bash

# Iterate over all .jpg files in the current directory
for file in *.jpg *.jpeg *.png *.JPG *.JPEG *.PNG; do
    # Check if file exists (in case there are no matching files)
    [ -e "$file" ] || continue

    # Extract the base name and extension of the file
    basename="${file%.*}"
    extension="${file##*.}"

    # Construct the output file path with -mush suffix
    output_file="${basename}-mush.${extension}"

    # Apply the posterize filter, grayscale filter, resize, and compress the image
    #magick "$file" -posterize 2 -colorspace Gray -resize "600x600>" "$output_file"
    #magick "$file" -dither FloydSteinberg -colors 2 -colorspace Gray -resize "600x600>" "$output_file"
    #magick "$file" -ordered-dither 8x8 -colors 2 -colorspace Gray -resize "500x500>" "$output_file"

    # TO SMALL FILE
    magick "$file" -resize "400x400>" "$output_file"


    # TO COMPRESSED GRAYSCALE
    #magick "$file" -colorSpace Gray -quality 20 "$output_file"

    echo "Processed $file -> $output_file"
done

