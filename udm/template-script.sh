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

awk \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v NRF="${NRF}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v UDM_PEM="${UDM_PEM:-cert/udm.pem}" \
	-v UDM_KEY="${UDM_KEY:-cert/udm.key}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	'{
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%NRF/, NRF);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%UDM_PEM/, UDM_PEM);
		sub(/%UDM_KEY/, UDM_KEY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
