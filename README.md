# GroundingDINO Local API
This repository provides a Docker-based setup to run [GroundingDINO](https://github.com/IDEA-Research/GroundingDINO) as a local REST API server.

![Screenshot 2025-04-20 235947](https://github.com/user-attachments/assets/9314d22e-77e6-4558-9d49-5a1b9a74c18e)

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

The endpoint accepts an image and a text prompt as input:

```bash
curl -X POST "http://localhost:8000/predict" \
-F "file=@your_image.jpg" \
-F "prompt=ball" \
-F "box_threshold=0.4" \
-F "text_threshold=0.3"
```

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
