#!/bin/bash

# Install required dependencies
pip install -r requirements.txt

# Convert notebook in the notebooks directory
cd notebooks
for notebook in *.ipynb; do
    if [ -f "$notebook" ]; then
        echo "Converting $notebook to Python script..."
        jupyter nbconvert --to script "$notebook"
        
        # Clean up the converted file
        py_file="${notebook%.ipynb}.py"
        if [ -f "$py_file" ]; then
            sed -i '/^get_ipython()/d' "$py_file"
            sed -i '/^%/d' "$py_file"
            echo "Successfully converted $notebook to $py_file"
        fi
    fi
done
cd ..