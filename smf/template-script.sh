#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
if [ -z "$N4" ]; then
	echo "Missing mandatory environment variable (N4)." > /dev/stderr
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
if [ -z "$SNSSAI_INFOS" ]; then
	echo "Missing mandatory environment variable (SNSSAI_INFOS)." > /dev/stderr
	exit 1
fi
if [ -z "$UP_NODES" ]; then
	echo "Missing mandatory environment variable (UP_NODES)." > /dev/stderr
	exit 1
fi
if [ -z "$LINKS" ]; then
	echo "Missing mandatory environment variable (LINKS)." > /dev/stderr
	exit 1
fi


IFS=$'\n'
SNSSAI_INFOS_SUB=""
for SNSSAI_INFO in ${SNSSAI_INFOS}; do
	if [ -n "${SNSSAI_INFO}" ]; then
		SNSSAI_INFOS_SUB="${SNSSAI_INFOS_SUB}\n    ${SNSSAI_INFO}"
	fi
done

UP_NODES_SUB=""
for UP_NODE in ${UP_NODES}; do
	if [ -n "${UP_NODE}" ]; then
		UP_NODES_SUB="${UP_NODES_SUB}\n      ${UP_NODE}"
	fi
done

LINKS_SUB=""
for LINK in ${LINKS}; do
	if [ -n "${LINK}" ]; then
		LINKS_SUB="${LINKS_SUB}\n      ${LINK}"
	fi
done

awk \
	-v N4="${N4}" \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v NRF="${NRF}" \
	-v LOCALITY="${LOCALITY:-area1}" \
	-v SNSSAI_INFOS="${SNSSAI_INFOS_SUB}" \
	-v UP_NODES="${UP_NODES_SUB}" \
	-v LINKS="${LINKS_SUB}" \
	-v ULCL="${ULCL:-false}" \
	'{
		sub(/%N4/, N4);
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%NRF/, NRF);
		sub(/%LOCALITY/, LOCALITY);
		sub(/%SNSSAI_INFOS/, SNSSAI_INFOS);
		sub(/%UP_NODES/, UP_NODES);
		sub(/%LINKS/, LINKS);
		sub(/%ULCL/, ULCL);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
