#!/bin/bash

set -e  # Exit on error
set -x  # Print commands for debugging

echo "Starting build process..."

# Install all required dependencies
pip install -r requirements.txt
pip install nbconvert jupytext

echo "Converting notebooks using jupytext (more reliable than nbconvert for this use case)..."

# Display current directory and contents
pwd
ls -la

# Go to notebooks directory
cd notebooks
echo "Contents of notebooks directory:"
ls -la

# Convert all notebooks to Python files using jupytext
echo "Converting all notebooks to Python..."
for notebook in *.ipynb; do
    if [ -f "$notebook" ]; then
        echo "Converting $notebook..."
        jupytext --to py:percent "$notebook"
        
        # Get the Python file name (replace .ipynb with .py)
        pyfile="${notebook%.ipynb}.py"
        
        if [ -f "$pyfile" ]; then
            echo "Successfully converted $notebook to $pyfile"
        else
            echo "Error: Conversion failed for $notebook"
            exit 1
        fi
    fi
done

# Verify the conversion
echo "Contents after conversion:"
ls -la

# Display all converted Python files
echo "Listing all converted Python files:"
find . -type f -name "*.py" -exec echo "- {}" \;

cd ..

echo "Final directory structure:"
find . -type f -name "*.py"

echo "Build process completed successfully!"