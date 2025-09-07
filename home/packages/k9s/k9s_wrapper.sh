#!/usr/bin/env bash

KUBERNETES_CONTEXT=$(kubectl config current-context)

SIT_SKIN="${SIT_SKIN:-"rose-pine-moon"}"
INT_SKIN="${INT_SKIN:-"default"}"
PROD_SKIN="${PROD_SKIN:-"orange"}"

if [[ $KUBERNETES_CONTEXT == *"sit"* ]]; then
    K9S_SKIN="$SIT_SKIN"
elif [[ $KUBERNETES_CONTEXT == *"int"* ]]; then
    K9S_SKIN="$INT_SKIN"
else
    # Use prod skin for the rest
    K9S_SKIN="$PROD_SKIN"
fi
    
K9S_SKIN=$K9S_SKIN k9s "$@"
