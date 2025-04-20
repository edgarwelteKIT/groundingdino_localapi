# GroundingDINO Local API
This repository provides a Docker-based setup to run GroundingDINO as a local REST API server.

## 🚀 Features
- Easily deploy GroundingDINO in a Docker container

- Expose a simple REST API to send images and text prompts

- Cross-platform support: Linux and Windows

## 🔧 Usage

### 1. Start the API Server

On Linux:
```bash
./start_docker.sh
```


On Windows:
```bash
./start_docker.bat
```

This will build the Docker image (if not already built) and start the API server.

### 2. Send Requests
Once the server is running, you can send HTTP POST requests to:

http://localhost:8000/predict

The endpoint accepts an image and a text prompt as input.

### 3. Example Client

You can test the API using the included Python script:

```bash
python api_client.py
```

This script demonstrates how to interact with the REST API programmatically using Python. It reads images either from the example video file or from a webcam.

## 📁 Contents

- `start_docker.sh` – Shell script to build and run the Docker container (Linux)

- `start_docker.bat` – Batch script for Windows

- `api_client.py` – Sample client script to test the API

- `Dockerfile` – Docker setup for the GroundingDINO server