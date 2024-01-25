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

awk \
	-v MONGO_HOST="${MONGO_HOST}" \
	-v MONGO_PORT="${MONGO_PORT:-27017}" \
	-v MONGO_NAME="${MONGO_NAME:-free5gc}" \
	-v SBI_REGISTER_IP="${SBI_REGISTER_IP}" \
	-v SBI_BINDING_IP="${SBI_BINDING_IP}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v NRF="${NRF}" \
	-v LOCALITY="${LOCALITY:-area1}" \
	-v PCF_NAME="${PCF_NAME:-PCF}" \
	'{
		sub(/%MONGO_HOST/, MONGO_HOST);
		sub(/%MONGO_PORT/, MONGO_PORT);
		sub(/%MONGO_NAME/, MONGO_NAME);
		sub(/%SBI_REGISTER_IP/, SBI_REGISTER_IP);
		sub(/%SBI_BINDING_IP/, SBI_BINDING_IP);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%NRF/, NRF);
		sub(/%LOCALITY/, LOCALITY);
		sub(/%PCF_NAME/, PCF_NAME);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
