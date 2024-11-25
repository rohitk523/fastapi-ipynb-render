from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import sys
from pathlib import Path

# Add the notebooks directory to Python path
notebook_path = Path(__file__).parent.parent / "notebooks"
sys.path.append(str(notebook_path))

# Import functions from converted notebook
try:
    # Import directly from the module (without 'notebooks.' prefix)
    from cluster_sample import process_data, your_function
except ImportError as e:
    print(f"Error importing notebook: {e}")
    print(f"Current sys.path: {sys.path}")  # For debugging
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)