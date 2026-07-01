#!/usr/bin/env bash

NAME=$1
OUT_DIR=$(mktemp -d)
GIT_ROOT=$(git rev-parse --show-toplevel)

CN="${NAME}.lan"

PKI_MOUNT="glusterfs_pki"
ROLE="glusterfs_role"
TTL="43800h" # 5 Years
RESPONSE_FILE="${OUT_DIR}/${CN}-vault-sign-response.json"


openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -keyout "${OUT_DIR}/${CN}.key" -out "${OUT_DIR}/${CN}.csr" -subj "/CN=${CN}"
bao write -format=json "${PKI_MOUNT}/sign/${ROLE}" \
  csr=@"${OUT_DIR}/${CN}.csr" \
  common_name="${CN}" \
  ttl="${TTL}" \
  > "$RESPONSE_FILE"

yq -r '.data.certificate' "$RESPONSE_FILE" > "${OUT_DIR}/${CN}.crt"
yq -r '.data.ca_chain[]' "$RESPONSE_FILE" > "${OUT_DIR}/${CN}-chain.crt"
cat "${OUT_DIR}/${CN}.crt" "${OUT_DIR}/${CN}-chain.crt" > "${OUT_DIR}/${CN}-fullchain.pem"


SECRET_DIR="${GIT_ROOT}/secrets/${NAME}"
mkdir -p "${SECRET_DIR}"
yq -r -n ".glusterpem = loadstr(\"${OUT_DIR}/${CN}-fullchain.pem\") | .key = loadstr(\"${OUT_DIR}/${CN}.key\")" > "${SECRET_DIR}/glusterfs.yaml"

sops -e -i "${SECRET_DIR}/glusterfs.yaml"

rm -r "${OUT_DIR}"
