from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import os
import sys
from pathlib import Path

print("Current working directory:", os.getcwd())
print("Directory contents:", os.listdir("."))
print("Notebooks directory contents:", os.listdir("notebooks"))

# Try to import from the converted notebook if available
notebook_functions_loaded = False

try:
    notebook_path = os.path.join(os.getcwd(), "notebooks")
    if notebook_path not in sys.path:
        sys.path.append(notebook_path)
    
    from cluster_sample import your_function
    from new_cluster import process_data
    notebook_functions_loaded = True
    print("Successfully loaded functions from notebook!")
except Exception as e:
    print(f"Error loading notebook functions: {e}")
    print("Using fallback functions")
    
    def process_data(numbers):
        return sum(numbers)
    
    def your_function():
        return "Hello from fallback function!"

app = FastAPI()

class DataInput(BaseModel):
    numbers: List[float]

@app.get("/")
def read_root():
    return {
        "message": "Hello from FastAPI!",
        "using_notebook_functions": notebook_functions_loaded
    }

@app.post("/process")
def process_numbers(data: DataInput):
    result = process_data(data.numbers)
    return {"result": result, "using_notebook_functions": notebook_functions_loaded}

@app.get("/notebook-endpoint")
def notebook_endpoint():
    return {"result": your_function(), "using_notebook_functions": notebook_functions_loaded}