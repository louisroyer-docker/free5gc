#!/usr/bin/env bash
# Copyright Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

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

awk \
	-v SBI_REGISTER_IPV4="${SBI_REGISTER_IPV4}" \
	-v SBI_BINDING_IPV4="${SBI_BINDING_IPV4}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v NRF_URI="http://${NRF}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v UDM_PEM="${UDM_PEM:-cert/udm.pem}" \
	-v UDM_KEY="${UDM_KEY:-cert/udm.key}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v LOG_ENABLE="${LOG_ENABLE:-true}" \
	-v LOG_REPORT_CALLER="${LOG_REPORT_CALLER:-false}" \
	'{
		sub(/%SBI_REGISTER_IPV4/, SBI_REGISTER_IPV4);
		sub(/%SBI_BINDING_IPV4/, SBI_BINDING_IPV4);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%NRF_URI/, NRF_URI);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%UDM_PEM/, UDM_PEM);
		sub(/%UDM_KEY/, UDM_KEY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%LOG_ENABLE/, LOG_ENABLE);
		sub(/%LOG_REPORT_CALLER/, LOG_REPORT_CALLER);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
