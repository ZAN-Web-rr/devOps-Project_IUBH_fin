# TechCorp Product Catalog API

A lightweight REST API built with Python and FastAPI. GitHub Actions runs tests and a Trivy scan, publishes an immutable container image to Google Artifact Registry, then deploys it to Cloud Run staging and production using keyless GitHub OIDC authentication.

## Tech Stack

* **Framework:** FastAPI (Python 3.13)
* **Server:** Uvicorn
* **Testing:** Pytest, Httpx
* **Containerization:** Docker, Docker Compose
* **CI/CD:** GitHub Actions, Google Artifact Registry, Google Cloud Run
* **Cloud authentication:** Workload Identity Federation (no service-account key files)

## Project Structure

```
├── .github/workflows/   # CI/CD pipeline definitions
├── app/                 # Application source code
│   └── main.py          # FastAPI application entry point
├── tests/               # Test suite
│   └── test_main.py     # API endpoint tests
├── Dockerfile           # Multi-stage docker build instructions
├── docker-compose.yml   # Local orchestration configuration
├── requirements.txt     # Runtime dependencies
└── requirements-dev.txt # Test and coverage dependencies
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
   pip install -r requirements-dev.txt
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
pip install -r requirements-dev.txt
pytest -q tests/ --cov=app --cov-report=term-missing
```

## Cloud Run CI/CD Setup

The workflow deploys only after a push to `main`; pull requests run CI only. Before enabling deployments:

1. In Google Cloud, enable billing and the Cloud Run, Artifact Registry, and IAM APIs. Create an Artifact Registry Docker repository in the selected region.
2. Configure Workload Identity Federation for this GitHub repository. Restrict the provider condition to `ZAN-Web-rr/devOps-Project_IUBH_fin` and `refs/heads/main`; do not create or upload a service-account JSON key.
3. Use separate build, staging-deploy, and production-deploy service accounts. Grant the build identity Artifact Registry Writer on the image repository. Grant deploy identities only the Cloud Run permissions and service-account access needed for their target service.
4. Add repository Actions variables: `GCP_PROJECT_ID`, `GCP_REGION`, `GAR_REPOSITORY`, `CLOUD_RUN_SERVICE`, `CLOUD_RUN_RUNTIME_SERVICE_ACCOUNT`, `GCP_BUILD_WIF_PROVIDER`, and `GCP_BUILD_SERVICE_ACCOUNT`.
5. Create GitHub Environments named `staging` and `production`. Set `GCP_STAGING_WIF_PROVIDER` and `GCP_STAGING_SERVICE_ACCOUNT` in the staging environment; set `GCP_PRODUCTION_WIF_PROVIDER` and `GCP_PRODUCTION_SERVICE_ACCOUNT` in production. Configure production required reviewers and restrict its deployment branch to `main`.

Cloud Run services scale from zero to at most one instance each. The current `techcorp-api-staging` and `techcorp-api` services are publicly invokable; this workflow does not change their invoker IAM policy. Its `/health` smoke tests use short-lived identity tokens, so they do not depend on public access. If public invocation is not required, remove `roles/run.invoker` from `allUsers` on each service separately; avoid project-wide public access. Record real deployment URLs and run evidence only after a successful GitHub Actions run.
