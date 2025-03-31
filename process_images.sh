#!/bin/bash
mkdir -p output

folder="test-data" 
for img in $folder/*.HEIC; do
    echo "Processing: $img"

    base="${img%.HEIC}"

    # Step 1: Convert .heic to .ppm (potrace-compatible)
    magick "$img" -colorspace Gray "cropped_$base.ppm"

    # Step 2: Resize to 400mm width (maintaining aspect ratio)
    # ImageMagick assumes 72 DPI by default, so 400mm ≈ 1134 pixels
    magick "cropped_$base.ppm" -resize 1134 "resized_$base.ppm"

    # Step 3: Vectorize with Potrace
    potrace -s --invert -o "output/$base.svg" "resized_$base.ppm" --opttolerance 0.05 --alphamax 0

    sed -i '' 's/<metadata>/<rect width="100%" height="100%" fill="black" \/><metadata>/' "output/$base.svg"
    sed -i '' 's/fill="#000000"/fill="#ffffff"/g' "output/$base.svg"
   
    magick "output/$base.svg" "output/$base.png"
    magick "output/$base.png" -fuzz 10% -trim +repage "output/$base.svg"

done

echo "✅ Conversion complete! SVG files are in the 'output' folder."
