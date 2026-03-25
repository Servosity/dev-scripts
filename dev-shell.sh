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

secret_json=$(aws secretsmanager get-secret-value \
    --secret-id "$SVT_SECRET_ENV_NAME/$SVT_SECRET_PROJECT/env" \
    --query SecretString \
    --output text \
    --profile svt-dev)

if [ $? -ne 0 ]; then
    echo "Error: Failed to retrieve secret from AWS Secrets Manager." >&2
    exit 1
fi

echo -ne "\033]0;dev-shell: $SVT_SECRET_PROJECT\007"  # Set window title
echo "*** Dev shell ready ***"
echo "Project: $SVT_SECRET_PROJECT"
echo "Secret: $SVT_SECRET_ENV_NAME"
echo
echo "$secret_json" | json-env-helper -- bash
echo -ne "\033]0;\007"  # Clear window title, letting the terminal revert to default
echo "*** Dev shell exited ***"
