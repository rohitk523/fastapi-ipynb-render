#!/bin/bash

# Start the FastAPI application
uvicorn api.main:app --host 0.0.0.0 --port $PORT