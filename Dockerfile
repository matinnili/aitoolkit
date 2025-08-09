# syntax=docker/dockerfile:1
FROM python:3.10-slim-buster

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1

# System deps for building wheels, git+ requirements, and OpenCV runtime
RUN apt-get update && apt-get install --no-install-recommends -y \
    git build-essential ffmpeg libgl1 libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first for better layer caching
COPY requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip install -r requirements.txt

# Copy the rest of the source
COPY . .

# Ensure the requested config path resolves:
# Copy the example config to the expected location/name (no extension needed on CLI)
RUN cp /app/config/examples/train_lora_flux_24gb.yaml /app/config/train_lora_flux_24gb.yaml

# Default command
CMD ["python", "run.py", "config/train_lora_flux_24gb"]