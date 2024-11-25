# FastAPI Notebook Deployment Guide

This guide will help you deploy your Jupyter notebooks as API endpoints using FastAPI and Render.

## Prerequisites
- A GitHub account
- A Render account (sign up at https://render.com if you don't have one)
- Your Jupyter notebook(s) ready to deploy

## Step 1: Set Up Your Repository

1. Go to https://github.com/rohitk523/fastapi-ipynb-render
2. Click the "Use this template" button
3. Name your new repository
4. Click "Create repository from template"

## Step 2: Prepare Your Notebook

1. Clone your new repository locally:
```bash
git clone [your-repository-url]
cd [repository-name]
```

2. Place your Jupyter notebook in the `notebooks` directory
   - Rename it to `cluster_sample.ipynb` or update the imports in `api/main.py`
   - Make sure your notebook contains functions you want to expose via API

3. Your notebook should define functions that can be imported. Example format:
```python
def process_data(numbers):
    # Your processing logic here
    return result

def your_function():
    # Your function logic here
    return result
```

## Step 3: Update the API Code

1. Open `api/main.py`
2. Update the imports to match your notebook's function names:
```python
from cluster_sample import your_function_name  # Change to match your functions
```

3. Update the API endpoints to use your functions:
```python
@app.post("/your-endpoint")
def your_endpoint(data: YourDataModel):
    result = your_function_name(data)
    return {"result": result}
```

## Step 4: Deploy to Render

1. Go to https://dashboard.render.com
2. Click "New +" and select "Web Service"
3. Connect to your GitHub repository
4. Configure the web service:
   - Name: Choose a name for your service
   - Runtime: Python
   - Build Command: `chmod +x build.sh && chmod +x start.sh && ./build.sh`
   - Start Command: `./start.sh`
   - Select the Free plan (or any other plan you prefer)

5. Click "Create Web Service"

## Step 5: Testing Your API

After deployment, Render will provide you with a URL. Test your endpoints:

1. Root endpoint:
```bash
curl https://your-service-name.onrender.com/
```

2. Process endpoint (example):
```bash
curl -X POST https://your-service-name.onrender.com/process \
  -H "Content-Type: application/json" \
  -d '{"numbers": [1, 2, 3, 4, 5]}'
```

3. Notebook endpoint:
```bash
curl https://your-service-name.onrender.com/notebook-endpoint
```

## Making Changes

When you want to update your notebook:

1. Make changes to your notebook in the `notebooks` directory
2. Commit and push your changes:
```bash
git add .
git commit -m "Update notebook"
git push
```
3. Render will automatically deploy your changes

## Project Structure
```
your-project/
├── api/
│   └── main.py          # FastAPI application
├── notebooks/
│   └── your_notebook.ipynb  # Your Jupyter notebook
├── build.sh             # Build script
├── start.sh            # Start script
├── requirements.txt     # Python dependencies
└── render.yaml         # Render configuration
```

## Important Notes

1. Make sure your notebook functions:
   - Don't rely on global variables
   - Have proper input/output parameters
   - Don't contain interactive widgets or display commands

2. If you change the notebook filename:
   - Update the import statement in `api/main.py`
   - Test locally before deploying

3. Monitor your deployment logs in Render dashboard for any errors

## Getting Help

If you encounter issues:
1. Check the Render deployment logs
2. Verify your notebook functions work locally
3. Ensure all dependencies are listed in `requirements.txt`

For more information:
- FastAPI documentation: https://fastapi.tiangolo.com/
- Render documentation: https://render.com/docs