#!/bin/bash
set -euo pipefail

aws ecs update-service \
    --cluster "${ECS_CLUSTER_NAME}" \
    --service "${ECS_SERVICE_NAME}" \
    --force-new-deployment \
    --region "${AWS_DEFAULT_REGION}" \
    --output text

echo "Waiting for service ${ECS_SERVICE_NAME} to stabilise..."

aws ecs wait services-stable \
    --cluster "${ECS_CLUSTER_NAME}" \
    --services "${ECS_SERVICE_NAME}" \
    --region "${AWS_DEFAULT_REGION}"

echo "Deploy complete."
