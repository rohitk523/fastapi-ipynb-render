from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import os
import sys
from pathlib import Path

# Add the project root to Python path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

# Import functions from converted notebook
try:
    # Import from notebooks directory
    from notebooks.cluster_sample import process_data, your_function
    print("Successfully imported notebook functions")
except ImportError as e:
    print(f"Error importing notebook: {e}")
    print(f"Current sys.path: {sys.path}")
    print(f"Current directory: {os.getcwd()}")
    print(f"Directory contents: {os.listdir('.')}")
    print(f"Notebooks directory contents: {os.listdir('notebooks')}")
    # Fallback functions for testing
    def process_data(numbers): return sum(numbers)
    def your_function(): return "Hello from fallback!"

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