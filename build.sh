#!/bin/bash

echo "Starting build process..."

# Install dependencies
pip install -r requirements.txt

# Go to notebooks directory
cd notebooks

# Remove any existing .py files
rm -f *.py

# Convert notebooks
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
            
            # Add empty __init__.py if it doesn't exist
            touch __init__.py
            
            echo "Successfully converted $notebook to $py_file"
        else
            echo "Failed to convert $notebook"
            exit 1
        fi
    fi
done

cd ..

echo "Build process completed."