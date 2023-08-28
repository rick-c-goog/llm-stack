#!/bin/bash

#1. Build llama 2 model container image:

cd llama2-7b/llama2-7b
gcloud build submit --region us-central1 --config cloudbuild.yaml

cd ../../web-app
gcloud build submit --region us-central1 --config cloudbuild.yaml

# Set the Terraform variables

cd ..

export TF_VAR_project_id=rick-devops-01
export TF_VAR_key_file=rick-devops-01-keys.json
export TF_VAR_region=us-central1
export TF_VAR_model=llama2-7b
export TF_VAR_hf_api_token=$HF_API_TOKEN


# Initialize Terraform
terraform init

# Validate the Terraform configuration
terraform validate

# Apply the deployment
terraform apply
# Sign in to Google Cloud
# printf "\n 🔐 Sign in to Google Cloud...\n"
# while true; do
#     printf "https://cloud.google.com/iam/docs/keys-create-delete\n\n"
#     read -p "Enter the path to your GCP service account key file: " PATH_TO_KEY_FILE

#     # Check if the file exists
#     if [[ -f "$PATH_TO_KEY_FILE" ]]; then
#         # Try to authenticate with Google Cloud
#         if gcloud auth activate-service-account --key-file="$PATH_TO_KEY_FILE"; then
#             # Authentication successful, break the loop
#             break
#         else
#             # Authentication failed, print an error message and continue the loop
#             echo "Failed to authenticate with Google Cloud. Please check your key file."
#         fi
#     else
#         # File does not exist, print an error message and continue the loop
#         echo "File does not exist. Please enter a valid path."
#     fi
# done

# # Ask for the project ID
# read -p "Enter your project ID: " YOUR_PROJECT_ID
# gcloud config set project $YOUR_PROJECT_ID

# read -p "Enter the GCP region (default: us-west1): " REGION
# REGION=${REGION:=us-west1}

# # Enable the Cloud Run API
# gcloud services enable run.googleapis.com

# # Deploy the base qdrant/qdrant:v1.3.0 image
# printf "\n💠 Deploy the qdrant/qdrant:v1.3.0 image...\n"
# VDB_IMAGE="qdrant/qdrant:v1.3.0"
# VDB_SERVICE_NAME="qdrant"

# # gcloud run deploy $VDB_SERVICE_NAME --image $VDB_IMAGE --region $REGION --platform managed --set-env-vars QDRANT__SERVICE__HTTP_PORT=8080

# # Build and deploy RagStack
# printf "\n🤖 Build and deploy RagStack...\n"
# DOCKERFILE_PATH="$(dirname "$0")/server"
# cd $DOCKERFILE_PATH

# read -p "Enter the image name (default: ragstack): " IMAGE_NAME
# IMAGE_NAME=${IMAGE_NAME:=ragstack}
# docker build -t $IMAGE_NAME .

# read -p "Enter the image tag (default: latest): " TAG
# TAG=${TAG:=latest}

# docker tag $IMAGE_NAME gcr.io/$YOUR_PROJECT_ID/$IMAGE_NAME:$TAG
# docker push gcr.io/$YOUR_PROJECT_ID/$IMAGE_NAME:$TAG

# read -p "Enter the service name for the new image (default: ragstack-service): " SERVICE_NAME

# SERVICE_NAME${SERVICE_NAME:=ragstack-service}
# gcloud run deploy $SERVICE_NAME --image gcr.io/$YOUR_PROJECT_ID/$IMAGE_NAME:$TAG --region $REGION --platform managed