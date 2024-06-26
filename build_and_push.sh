#!/bin/bash

# Variables
REPO_URL=$1
REGION=$2
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
IMAGE_TAG=latest

# Authenticate Docker to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# Build the Docker image
docker build -t ${REPO_URL}:${IMAGE_TAG} .

# Push the Docker image to ECR
docker push ${REPO_URL}:${IMAGE_TAG}
