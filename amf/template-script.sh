#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$N2" ]; then
	echo "Missing mandatory environment variable (N2)." > /dev/stderr
	exit 1
fi
if [ -z "$SBI_REGISTER_IP" ]; then
	echo "Missing mandatory environment variable (SBI_REGISTER_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$SBI_BINDING_IP" ]; then
	echo "Missing mandatory environment variable (SBI_BINDING_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$NRF" ]; then
	echo "Missing mandatory environment variable (NRF)." > /dev/stderr
	exit 1
fi
if [ -z "$SUPPORT_DNN_LIST" ]; then
	echo "Missing mandatory environment variable (SUPPORTED_DNN_LIST)." > /dev/stderr
	exit 1
fi
if [ -z "$SNSSAI_LIST" ]; then
	echo "Missing mandatory environment variable (SNSSAI_LIST)." > /dev/stderr
	exit 1
fi

IFS=$'\n'
SUPPORT_DNN_LIST_SUB=""
for DNN in ${SUPPORT_DNN_LIST}; do
	if [ -n "${DNN}" ]; then
		SUPPORT_DNN_LIST_SUB="${SUPPORT_DNN_LIST_SUB}\n    ${DNN}"
	fi
done

SNSSAI_LIST_SUB=""
for SNSSAI in ${SNSSAI_LIST}; do
	if [ -n "${SNSSAI}" ]; then
		SNSSAI_LIST_SUB="${SNSSAI_LIST_SUB}\n        ${SNSSAI}"
	fi
done

awk \
	-v N2="${N2}" \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v AMF_ID="${AMF_ID:-000001}" \
	-v AMF_NAME="${AMF_NAME:-AMF}" \
	-v NRF="${NRF}" \
	-v SUPPORT_DNN_LIST="${SUPPORT_DNN_LIST_SUB}" \
	-v SNSSAI_LIST="${SNSSAI_LIST_SUB}" \
	-v TAC="${TAC:-000001}" \
	-v LOCALITY="${LOCALITY:-area1}" \
	'{
		sub(/%N2/, N2);
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%AMF_ID/, AMF_ID);
		sub(/%AMF_NAME/, AMF_NAME);
		sub(/%NRF/, NRF);
		sub(/%SUPPORT_DNN_LIST/, SUPPORT_DNN_LIST);
		sub(/%SNSSAI_LIST/, SNSSAI_LIST);
		sub(/%TAC/, TAC);
		sub(/%LOCALITY/, LOCALITY);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
