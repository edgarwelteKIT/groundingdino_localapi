@echo off
echo Building Docker image...
docker build -t groundingdino_localapi .
IF %ERRORLEVEL% NEQ 0 (
    echo Docker build failed. Exiting.
    exit /b 1
)

REM Check if the Docker container already exists (regardless of state)
docker ps -a -q -f name=groundingdino_localapi_container > tmp_container.txt
set /p CONTAINER_ID=<tmp_container.txt
del tmp_container.txt

IF NOT "%CONTAINER_ID%"=="" (
    echo Stopping and removing existing Docker container...
    docker stop groundingdino_localapi_container >nul 2>&1
    docker rm groundingdino_localapi_container >nul 2>&1
)

echo Starting Docker container...
docker run --gpus all -d --name groundingdino_localapi_container -p 8000:8000 groundingdino_localapi

IF %ERRORLEVEL% EQU 0 (
    echo Docker container started successfully.
    echo Streaming logs from the container...
    docker logs -f groundingdino_localapi_container
) ELSE (
    echo Failed to start Docker container.
    exit /b 1
)
