#!/bin/bash

# Install dependencies
pip install -r requirements.txt

# Convert notebook in the notebooks directory
cd notebooks
for notebook in *.ipynb; do
    if [ -f "$notebook" ]; then
        echo "Converting $notebook to Python script..."
        python -m jupyter nbconvert --to python "$notebook"
        
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

# Start the FastAPI application using uvicorn
uvicorn api.main:app --host 0.0.0.0 --port "${PORT:-8000}"