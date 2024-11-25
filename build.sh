#!/bin/bash

echo "Starting build process..."

# Install dependencies
pip install -r requirements.txt

# Create __init__.py in notebooks directory if it doesn't exist
touch notebooks/__init__.py

# Convert notebooks
cd notebooks
for notebook in *.ipynb; do
    if [ -f "$notebook" ]; then
        echo "Converting $notebook to Python script..."
        python -m jupyter nbconvert --to python "$notebook"
        
        # Clean up the converted file
        py_file="${notebook%.ipynb}.py"
        if [ -f "$py_file" ]; then
            # Remove IPython specific commands
            sed -i '/^get_ipython()/d' "$py_file"
            sed -i '/^%/d' "$py_file"
            echo "Successfully converted $notebook to $py_file"
            
            # Print the contents of the converted file for debugging
            echo "Contents of $py_file:"
            cat "$py_file"
        else
            echo "Failed to convert $notebook"
            exit 1
        fi
    fi
done
cd ..

# Print directory structure for debugging
echo "Final directory structure:"
find . -type f -name "*.py" -o -name "*.ipynb"

echo "Build process completed."