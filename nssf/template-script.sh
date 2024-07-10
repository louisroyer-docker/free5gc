#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

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

IFS=$'\n'
SUPPORTED_NSSAI_IN_PLMN_LIST_SUB=""
for SUPPORTED_NSSAI_IN_PLMN in ${SUPPORTED_NSSAI_IN_PLMN_LIST}; do
	if [ -n "${SUPPORTED_NSSAI_IN_PLMN}" ]; then
		SUPPORTED_NSSAI_IN_PLMN_LIST_SUB="${SUPPORTED_NSSAI_IN_PLMN_LIST_SUB}\n    ${SUPPORTED_NSSAI_IN_PLMN}"
	fi
done
NSI_LIST_SUB=""
for NSI in ${NSI_LIST}; do
	if [ -n "${NSI}" ]; then
		NSI_LIST_SUB="${NSI_LIST_SUB}\n    ${NSI}"
	fi
done

AMF_SET_LIST_SUB=""
for AMF_SET in ${AMF_SET_LIST}; do
	if [ -n "${AMF_SET}" ]; then
		AMF_SET_LIST_SUB="${AMF_SET_LIST_SUB}\n    ${AMF_SET}"
	fi
done

AMF_LIST_SUB=""
for AMF in ${AMF_LIST}; do
	if [ -n "${AMF}" ]; then
		AMF_LIST_SUB="${AMF_LIST_SUB}\n    ${AMF}"
	fi
done

TA_LIST_SUB=""
for TA in ${TA_LIST}; do
	if [ -n "${TA}" ]; then
		TA_LIST_SUB="${TA_LIST_SUB}\n    ${TA}"
	fi
done

MAPPING_LIST_FROM_PLMN_SUB=""
for MAPPING in ${MAPPING_LIST_FROM_PLMN}; do
	if [ -n "${MAPPING}" ]; then
		MAPPING_LIST_FROM_PLMN_SUB="${MAPPING_LIST_FROM_PLMN_SUB}\n    ${MAPPING}"
	fi
done

awk \
	-v NSSF_NAME="${NSSF_NAME:-NSSF}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v SUPPORTED_NSSAI_IN_PLMN_LIST="${SUPPORTED_NSSAI_IN_PLMN_LIST_SUB}" \
	-v NSI_LIST="${NSI_LIST_SUB}" \
	-v AMF_SET_LIST="${AMF_SET_LIST_SUB}" \
	-v AMF_LIST="${AMF_LIST_SUB}" \
	-v TA_LIST="${TA_LIST_SUB}" \
	-v MAPPING_LIST_FROM_PLMN="${MAPPING_LIST_FROM_PLMN_SUB}" \
	-v NRF="${NRF}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v NSSF_PEM="${NSSF_PEM:-cert/nssf.pem}" \
	-v NSSF_KEY="${NSSF_KEY:-cert/nssf.key}" \
	'{
		sub(/%NSSF_NAME/, NSSF_NAME);
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%NRF/, NRF);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%NSSF_PEM/, NSSF_PEM);
		sub(/%NSSF_KEY/, NSSF_KEY);
		sub(/%SUPPORTED_NSSAI_IN_PLMN_LIST/, SUPPORTED_NSSAI_IN_PLMN_LIST);
		sub(/%NSI_LIST/, NSI_LIST);
		sub(/%AMF_SET_LIST/, AMF_SET_LIST);
		sub(/%AMF_LIST/, AMF_LIST);
		sub(/%TA_LIST/, TA_LIST);
		sub(/%MAPPING_LIST_FROM_PLMN/, MAPPING_LIST_FROM_PLMN);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
