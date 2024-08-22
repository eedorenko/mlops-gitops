#!/bin/bash

# Usage:
# generate-deployment-descriptor.sh DEPLOYMENT_TARGET DEPLOYMENT_TARGET_MANIFESTS_PATH OUTPUT_FILE TEMPLATE_FILE

export DEPLOYMENT_TARGET=$1
export DEPLOYMENT_TARGET_MANIFESTS_PATH=$2
OUTPUT_FILE=$3
TEMPLATE_FILE=$4

echo $DEPLOYMENT_TARGET
echo $DEPLOYMENT_TARGET_MANIFESTS_PATH
echo $OUTPUT_FILE
echo $TEMPLATE_FILE


set -eo pipefail

envsubst <"$TEMPLATE_FILE" > "$OUTPUT_FILE"