#!/bin/bash
mkdir -p output

folder="herbs"
for img in $folder/*.jpeg; do
    echo "Processing: $img"

    base="${img%.jpeg}"

    # Step 1: Convert .jpeg to .ppm (potrace-compatible)
    magick "$img" -colorspace Gray "$base.ppm"

    # Step 2: Vectorize with Potrace
    potrace -s --invert -o "output/$base.svg" "$base.ppm" --opttolerance 0.05 --alphamax 0

    sed -i '' 's/<metadata>/<rect width="100%" height="100%" fill="black" \/><metadata>/' "output/$base.svg"
    sed -i '' 's/fill="#000000"/fill="#ffffff"/g' "output/$base.svg"
   
#    magick "output/$base.svg" "output/$base.png"
#    magick "output/$base.png" -fuzz 10% -trim +repage "output/$base.svg"

done

echo "✅ Conversion complete! SVG files are in the 'output' folder."
