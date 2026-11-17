from fastapi import FastAPI
import os
import time

app = FastAPI(title="TechCorp DevOps Case Study API")

start_time = time.time()

@app.get("/")
def read_root():
    return {"message": "Welcome to TechCorp DevOps API (Python 3)"}

@app.get("/health")
def health_check():
    uptime = time.time() - start_time
    return {
        "status": "UP",
        "uptime_seconds": round(uptime, 2),
        "environment": os.getenv("ENVIRONMENT", "development")
    }

@app.get("/api/v1/products")
def get_products():
    return {
        "success": True,
        "data": [
            {"id": 1, "name": "Cloud Compute Instance", "price": 49.99},
            {"id": 2, "name": "Managed Kubernetes", "price": 199.99}
        ]
    }
