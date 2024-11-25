#!/bin/bash

set -e  # Exit on error
set -x  # Print commands for debugging

echo "Starting build process..."

# Install dependencies
pip install -r requirements.txt

# Display current directory and contents
pwd
ls -la

# Go to notebooks directory and convert
cd notebooks
echo "Contents of notebooks directory:"
ls -la

# Convert the notebook
echo "Converting notebook..."
jupyter-nbconvert --to python cluster_sample.ipynb

# Verify the conversion
echo "Contents after conversion:"
ls -la

# Display the converted file contents
echo "Contents of converted Python file:"
cat cluster_sample.py

cd ..

echo "Final directory structure:"
find . -type f -name "*.py"

echo "Build process completed."