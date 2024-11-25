from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import os
import sys
from pathlib import Path

print("Current working directory:", os.getcwd())
print("Directory contents:", os.listdir("."))

# Define the notebook functions here as fallback
def process_data(numbers):
    return sum(numbers)

def your_function():
    return "Hello from converted notebook!"

# Try to import from the converted notebook if available
try:
    sys.path.append(os.getcwd())
    if os.path.exists("notebooks/cluster_sample.py"):
        print("Found converted notebook file")
        from notebooks.cluster_sample import process_data, your_function
        print("Successfully imported notebook functions")
    else:
        print("Using fallback functions - notebook file not found")
        # We'll use the fallback functions defined above
except Exception as e:
    print(f"Error importing notebook: {e}")
    print(f"Using fallback functions due to import error")
    # We'll use the fallback functions defined above

app = FastAPI()

class DataInput(BaseModel):
    numbers: List[float]

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI!"}

@app.post("/process")
def process_numbers(data: DataInput):
    result = process_data(data.numbers)
    return {"result": result}

@app.get("/notebook-endpoint")
def notebook_endpoint():
    return {"result": your_function()}