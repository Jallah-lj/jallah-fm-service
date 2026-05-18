#!/bin/bash
set -euo pipefail

REGION="us-east-1"
SERVICE_NAME="${SERVICE_NAME:-staging}"
IMAGE_URI="${AWS_ECR_DOMAIN}/fem-fd-service:${BUILD_TAG:-staging}"
INSTANCE_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/fem-fd-service-app-runner-role"
ACCESS_ROLE_NAME="fem-fd-service-apprunner-ecr-role"
ACCESS_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/${ACCESS_ROLE_NAME}"

echo "Deploying ${IMAGE_URI} to App Runner service '${SERVICE_NAME}' in ${REGION}..."

# Create ECR access role if it doesn't exist
if ! aws iam get-role --role-name "${ACCESS_ROLE_NAME}" &>/dev/null; then
    echo "Creating App Runner ECR access role..."
    aws iam create-role \
        --role-name "${ACCESS_ROLE_NAME}" \
        --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"build.apprunner.amazonaws.com"},"Action":"sts:AssumeRole"}]}'
    aws iam attach-role-policy \
        --role-name "${ACCESS_ROLE_NAME}" \
        --policy-arn arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess
fi

SOURCE_CONFIG=$(cat <<JSON
{
    "ImageRepository": {
        "ImageIdentifier": "${IMAGE_URI}",
        "ImageRepositoryType": "ECR",
        "ImageConfiguration": {
            "Port": "8080",
            "RuntimeEnvironmentSecrets": {
                "POSTGRES_URL": "arn:aws:ssm:${REGION}:${AWS_ACCOUNT_ID}:parameter/POSTGRES_URL"
            }
        }
    },
    "AuthenticationConfiguration": {
        "AccessRoleArn": "${ACCESS_ROLE_ARN}"
    },
    "AutoDeploymentsEnabled": false
}
JSON
)

SERVICE_ARN=$(aws apprunner list-services \
    --region "${REGION}" \
    --query "ServiceSummaryList[?ServiceName=='${SERVICE_NAME}'].ServiceArn" \
    --output text)

if [ -z "${SERVICE_ARN}" ]; then
    echo "Creating App Runner service '${SERVICE_NAME}'..."
    aws apprunner create-service \
        --service-name "${SERVICE_NAME}" \
        --region "${REGION}" \
        --source-configuration "${SOURCE_CONFIG}" \
        --instance-configuration "{\"InstanceRoleArn\":\"${INSTANCE_ROLE_ARN}\"}"
else
    echo "Updating App Runner service '${SERVICE_NAME}'..."
    aws apprunner update-service \
        --service-arn "${SERVICE_ARN}" \
        --region "${REGION}" \
        --source-configuration "${SOURCE_CONFIG}"
fi

echo "Deploy complete."
