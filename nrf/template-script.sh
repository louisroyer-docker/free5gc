#!/usr/bin/env bash
# Copyright Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$MONGO_HOST" ]; then
	echo "Missing mandatory environment variable (MONGO_HOST)." > /dev/stderr
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

awk \
	-v MONGO_HOST="${MONGO_HOST}" \
	-v MONGO_PORT="${MONGO_PORT:-27017}" \
	-v MONGO_NAME="${MONGO_NAME:-free5gc}" \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v NRF_KEY="${NRF_KEY:-cert/nrf.key}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v LOG_ENABLE="${LOG_ENABLE:-true}" \
	-v LOG_REPORT_CALLER="${LOG_REPORT_CALLER:-false}" \
	-v OAUTH_ENABLE="${OAUTH_ENABLE:-false}" \
	'{
		sub(/%MONGO_HOST/, MONGO_HOST);
		sub(/%MONGO_PORT/, MONGO_PORT);
		sub(/%MONGO_NAME/, MONGO_NAME);
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%NRF_KEY/, NRF_KEY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%LOG_ENABLE/, LOG_ENABLE);
		sub(/%LOG_REPORT_CALLER/, LOG_REPORT_CALLER);
		sub(/%OAUTH_ENABLE/, OAUTH_ENABLE);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
