# Use Python 2.7 (with security note) - upgrading to Python 3 requires extensive testing
FROM python:2.7-slim

WORKDIR /app

ENV PYTHONPATH=$PYTHONPATH:/app

# Create a non-root user for security
RUN useradd --create-home --shell /bin/bash hyphe

# Copy requirements first for better caching
COPY requirements.txt /app/requirements.txt

# Install dependencies with security best practices - removed deprecated repo fix
RUN buildDeps='gcc libffi-dev libxml2-dev libxslt-dev' \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps \
    && pip install --no-cache-dir --upgrade pip setuptools \
    && pip install --no-cache-dir -r /app/requirements.txt \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Copy application files
COPY ./bin /app/bin
COPY ./config /app/config.sample
COPY ./hyphe_backend /app/hyphe_backend
COPY ./docker-entrypoint.py /app/docker-entrypoint.py

# Create config directory and set proper permissions
RUN mkdir -p /app/config /app/traph-data \
    && chmod +x /app/docker-entrypoint.py \
    && chmod +x /app/hyphe_backend/core.tac \
    && chown -R hyphe:hyphe /app

# Switch to non-root user
USER hyphe

EXPOSE 6978

VOLUME ["/app/config"]
VOLUME ["/app/traph-data"]

ENTRYPOINT ["/app/docker-entrypoint.py"]
