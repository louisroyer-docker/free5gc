#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
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
if [ -z "$NRF" ]; then
	echo "Missing mandatory environment variable (NRF)." > /dev/stderr
	exit 1
fi
if [ -z "$BILLING_IP" ]; then
	echo "Missing mandatory environment variable (BILLING_IP)." > /dev/stderr
	exit 1
fi

awk \
	-v MONGO_HOST="${MONGO_HOST}" \
	-v MONGO_PORT="${MONGO_PORT:-27017}" \
	-v MONGO_NAME="${MONGO_NAME:-free5gc}" \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v NRF="${NRF}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v BILLING_IP="${BILLING_IP}" \
	-v BILLING_ENABLE="${BILLING_ENABLE:-true}" \
	-v CHF_NAME="${CHF_NAME:-CHF}" \
	-v CHF_PEM="${CHF_PEM:-cert/chf.pem}" \
	-v CHF_KEY="${CHF_KEY:-cert/chf.key}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	'{
		sub(/%MONGO_HOST/, MONGO_HOST);
		sub(/%MONGO_PORT/, MONGO_PORT);
		sub(/%MONGO_NAME/, MONGO_NAME);
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%NRF/, NRF);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%BILLING_ENABLE/, BILLING_ENABLE);
		sub(/%BILLING_IP/, BILLING_IP);
		sub(/%CHF_NAME/, CHF_NAME);
		sub(/%CHF_PEM/, CHF_PEM);
		sub(/%CHF_KEY/, CHF_KEY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
