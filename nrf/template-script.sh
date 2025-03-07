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

awk \
	-v MONGO_HOST="${MONGO_HOST}" \
	-v MONGO_PORT="${MONGO_PORT:-27017}" \
	-v MONGO_NAME="${MONGO_NAME:-free5gc}" \
	-v SBI_REGISTER_IPV4="${SBI_REGISTER_IPV4}" \
	-v SBI_BINDING_IPV4="${SBI_BINDING_IPV4}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v NRF_KEY="${NRF_KEY:-cert/nrf.key}" \
	-v ROOT_PEM="${ROOT_PEM:-cert/root.pem}" \
	-v ROOT_KEY="${ROOT_KEY:-cert/root.key}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v LOG_ENABLE="${LOG_ENABLE:-true}" \
	-v LOG_REPORT_CALLER="${LOG_REPORT_CALLER:-false}" \
	-v OAUTH_ENABLE="${OAUTH_ENABLE:-false}" \
	'{
		sub(/%MONGO_HOST/, MONGO_HOST);
		sub(/%MONGO_PORT/, MONGO_PORT);
		sub(/%MONGO_NAME/, MONGO_NAME);
		sub(/%SBI_REGISTER_IPV4/, SBI_REGISTER_IPV4);
		sub(/%SBI_BINDING_IPV4/, SBI_BINDING_IPV4);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%NRF_KEY/, NRF_KEY);
		sub(/%ROOT_PEM/, ROOT_PEM);
		sub(/%ROOT_KEY/, ROOT_KEY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%LOG_ENABLE/, LOG_ENABLE);
		sub(/%LOG_REPORT_CALLER/, LOG_REPORT_CALLER);
		sub(/%OAUTH_ENABLE/, OAUTH_ENABLE);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
