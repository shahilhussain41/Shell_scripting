#!/bin/bash
# Simple File/Directory Compression Script
# This script takes a file or directory as input
# and compresses it into a .tar.gz archive.

# user to enter file or folder path for compression
echo "Enter the file or directory path to compress:"
read INPUT   # Read user input and store in variable INPUT

# user to enter output filename for compressed archive
echo "Enter the output compressed file name (e.g., backup.tar.gz):"
read OUTPUT  # Read user input and store in variable OUTPUT

# Run tar command:
# -c = create archive
# -z = compress using gzip
# -v = verbose (show progress)
# -f = specify filename
tar -czvf $OUTPUT $INPUT

# Show success message with details
echo "✅ Compression completed!"
echo "Input: $INPUT"     # Show original input path
echo "Output: $OUTPUT"   # Show compressed output file
