# Stage 1: Builder
FROM python:3.13-alpine AS builder

WORKDIR /app
COPY requirements.txt .

# Install dependencies into a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.13-alpine AS runner

WORKDIR /app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy virtual environment and source code
COPY --from=builder /opt/venv /opt/venv
COPY app /app/app

ENV PATH="/opt/venv/bin:$PATH"
ENV ENVIRONMENT="production"
ENV PORT=8080

# Switch to non-root user
USER appuser

EXPOSE 8080

# Healthcheck for container orchestration
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider "http://localhost:${PORT:-8080}/health" || exit 1

CMD ["sh", "-c", "exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8080}"]
