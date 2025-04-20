@echo off
echo Building Docker image...
docker build -t groundingdino_localapi .
IF %ERRORLEVEL% NEQ 0 (
    echo Docker build failed. Exiting.
    exit /b 1
)

REM Check if the Docker container is already running
FOR /F "tokens=* USEBACKQ" %%F IN (`docker ps -q -f name=groundingdino_localapi_container`) DO (
    echo Stopping existing Docker container...
    docker stop groundingdino_localapi_container
)

REM Check if an exited container with the same name exists
FOR /F "tokens=* USEBACKQ" %%F IN (`docker ps -aq -f status=exited -f name=groundingdino_localapi_container`) DO (
    echo Removing existing Docker container...
    docker rm groundingdino_localapi_container
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
