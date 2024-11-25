#!/bin/bash

echo "Starting build process..."

# Install dependencies
pip install -r requirements.txt

# Ensure we're in the correct directory
cd "$(dirname "$0")"

# Create notebooks directory if it doesn't exist
mkdir -p notebooks

# Create __init__.py in notebooks directory
touch notebooks/__init__.py

# Go to notebooks directory
cd notebooks

echo "Current directory: $(pwd)"
echo "Directory contents before conversion:"
ls -la

# Convert notebooks
for notebook in *.ipynb; do
    if [ -f "$notebook" ]; then
        echo "Converting $notebook to Python script..."
        jupyter nbconvert --to python "$notebook"
        
        # Clean up the converted file
        py_file="${notebook%.ipynb}.py"
        if [ -f "$py_file" ]; then
            # Remove IPython specific commands
            sed -i '/^get_ipython()/d' "$py_file"
            sed -i '/^%/d' "$py_file"
            echo "Successfully converted $notebook to $py_file"
            
            # Print the contents of the converted file
            echo "Contents of $py_file:"
            cat "$py_file"
        else
            echo "Failed to convert $notebook"
            exit 1
        fi
    fi
done

echo "Directory contents after conversion:"
ls -la

cd ..