# Product Catalog API

A lightweight REST API service built with Python and FastAPI for managing product catalog data. This project includes a continuous integration and deployment pipeline using GitHub Actions and Docker.

## Tech Stack

* **Framework:** FastAPI (Python 3.13)
* **Server:** Uvicorn
* **Testing:** Pytest, Httpx
* **Containerization:** Docker, Docker Compose
* **CI/CD:** GitHub Actions

## Project Structure

```
├── .github/workflows/   # CI/CD pipeline definitions
├── app/                 # Application source code
│   └── main.py          # FastAPI application entry point
├── tests/               # Test suite
│   └── test_main.py     # API endpoint tests
├── Dockerfile           # Multi-stage docker build instructions
├── docker-compose.yml   # Local orchestration configuration
└── requirements.txt     # Python dependencies
```

## Running Locally

### Using Python

1. Clone the repository and navigate to the project directory.
2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Start the development server:
   ```bash
   uvicorn app.main:app --reload
   ```

### Using Docker

To spin up the service using Docker Compose:

```bash
docker-compose up -d --build
```

The API will be available at `http://localhost:8000`.

## API Endpoints

* `GET /` - Root endpoint, returns a welcome message.
* `GET /health` - Health check endpoint returning uptime and environment details.
* `GET /api/v1/products` - Returns a list of available products.

## Testing

To run the automated test suite, ensure your virtual environment is active and run:

```bash
pytest
```
