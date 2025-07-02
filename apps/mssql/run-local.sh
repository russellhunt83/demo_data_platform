#!/bin/bash

# Prompt for SA_PASSWORD if not set
if [ -z "$SA_PASSWORD" ]; then
    read -s -p "Enter SA_PASSWORD for MSSQL: " SA_PASSWORD
    echo
fi

DOCKER_CONTAINER=demo-mssql
SERVICE_NAME=MSSQL
PORT_EXPOSE=1433
PORT_EXPOSED=1433
echo "Stopping any existing ${SERVICE_NAME} containers..."
docker compose down

echo "Attempting to start ${SERVICE_NAME} container..."
docker build -t ${DOCKER_CONTAINER} --build-arg SA_PASSWORD_ARG=${SA_PASSWORD} .

if docker container ls -a --filter "name=${DOCKER_CONTAINER}" --format '{{.Names}}'; then
    docker container stop ${DOCKER_CONTAINER}
    docker container rm ${DOCKER_CONTAINER}
    
fi

docker run -d  --name ${DOCKER_CONTAINER} -p $PORT_EXPOSE:$PORT_EXPOSED  ${DOCKER_CONTAINER}

# Check if the ${DOCKER_CONTAINER} container is running
if docker ps --filter "name=${DOCKER_CONTAINER}" --format '{{.Names}}' | grep -q "^${DOCKER_CONTAINER}$"; then
    echo "${SERVICE_NAME} container is running."
else
    echo "Failed to start ${SERVICE_NAME} container."
    exit 1
fi