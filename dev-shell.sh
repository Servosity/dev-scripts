#!/bin/bash

if ! command -v aws &> /dev/null; then
    echo "Error: aws CLI is not available on PATH." >&2
    exit 1
fi

if ! command -v json-env-helper &> /dev/null; then
    echo "Error: json-env-helper is not available on PATH." >&2
    exit 1
fi

if [ -z "$SVT_SECRET_ENV_NAME" ]; then
    echo "Error: SVT_SECRET_ENV_NAME is not set." >&2
    exit 1
fi

if [ -z "$SVT_SECRET_PROJECT" ]; then
    echo "Error: SVT_SECRET_PROJECT is not set." >&2
    exit 1
fi

aws secretsmanager get-secret-value \
    --secret-id "$SVT_SECRET_ENV_NAME/$SVT_SECRET_PROJECT/env" \
    --query SecretString \
    --output text \
    --profile svt-dev \
    | json-env-helper -- bash
