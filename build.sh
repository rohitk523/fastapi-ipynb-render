#!/bin/bash

echo "Starting build process..."

# Install dependencies
pip install -r requirements.txt

# Remove any existing .py files in notebooks directory to ensure clean conversion
cd notebooks
rm -f *.py

# Convert notebooks
for notebook in *.ipynb; do
    if [ -f "$notebook" ]; then
        echo "Converting $notebook to Python script..."
        python -m jupyter nbconvert --to python "$notebook" --output-dir=.
        
        # Clean up the converted file
        py_file="${notebook%.ipynb}.py"
        if [ -f "$py_file" ]; then
            # Remove IPython specific commands
            sed -i '/^get_ipython()/d' "$py_file"
            sed -i '/^%/d' "$py_file"
            echo "Successfully converted $notebook to $py_file"
        else
            echo "Failed to convert $notebook"
            exit 1
        fi
    fi
done

cd ..

echo "Build process completed."