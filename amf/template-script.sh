#!/usr/bin/env bash
# Copyright Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$N2" ]; then
	echo "Missing mandatory environment variable (N2)." > /dev/stderr
	exit 1
fi
if [ -z "$SBI_BINDING_IPV4" ]; then
	if [ -z "$SBI_BINDING_IP" ]; then
		echo "Missing mandatory environment variable (SBI_BINDING_IPV4)." > /dev/stderr
		exit 1
	else
		echo "Warning: SBI_BINDING_IP is deprecated. Use SBI_BINDING_IPV4 instead." > /dev/stderr
		SBI_BINDING_IPV4="${SBI_BINDING_IP}"
	fi
fi
if [ -z "$SBI_REGISTER_IPV4" ]; then
	if [ -z "$SBI_REGISTER_IP" ]; then
		# fallback on SBI_BINDING_IPV4
		SBI_REGISTER_IPV4="${SBI_BINDING_IPV4}"
		exit 1
	else
		echo "Warning: SBI_REGISTER_IP is deprecated. Use SBI_REGISTER_IPV4 instead." > /dev/stderr
		SBI_REGISTER_IPV4="${SBI_REGISTER_IP}"
	fi
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
	-v SBI_REGISTER_IPV4="${SBI_REGISTER_IPV4}" \
	-v SBI_BINDING_IPV4="${SBI_BINDING_IPV4}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v AMF_ID="${AMF_ID:-000001}" \
	-v AMF_NAME="${AMF_NAME:-AMF}" \
	-v AMF_PEM="${AMF_PEM:-cert/amf.pem}" \
	-v AMF_KEY="${AMF_KEY:-cert/amf.key}" \
	-v NRF_URI="http://${NRF}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v SUPPORT_DNN_LIST="${SUPPORT_DNN_LIST_SUB}" \
	-v SNSSAI_LIST="${SNSSAI_LIST_SUB}" \
	-v TAC="${TAC:-000001}" \
	-v LOCALITY="${LOCALITY:-area1}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v LOG_ENABLE="${LOG_ENABLE:-true}" \
	-v LOG_REPORT_CALLER="${LOG_REPORT_CALLER:-false}" \
	'{
		sub(/%N2/, N2);
		sub(/%SBI_REGISTER_IPV4/, SBI_REGISTER_IPV4);
		sub(/%SBI_BINDING_IPV4/, SBI_BINDING_IPV4);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%AMF_ID/, AMF_ID);
		sub(/%AMF_NAME/, AMF_NAME);
		sub(/%AMF_PEM/, AMF_PEM);
		sub(/%AMF_KEY/, AMF_KEY);
		sub(/%NRF_URI/, NRF_URI);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%SUPPORT_DNN_LIST/, SUPPORT_DNN_LIST);
		sub(/%SNSSAI_LIST/, SNSSAI_LIST);
		sub(/%TAC/, TAC);
		sub(/%LOCALITY/, LOCALITY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%LOG_ENABLE/, LOG_ENABLE);
		sub(/%LOG_REPORT_CALLER/, LOG_REPORT_CALLER);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
