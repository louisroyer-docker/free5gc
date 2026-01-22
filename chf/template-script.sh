#!/usr/bin/env bash
# Copyright Louis Royer. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

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
	-v SBI_REGISTER_IPV4="${SBI_REGISTER_IPV4}" \
	-v SBI_BINDING_IPV4="${SBI_BINDING_IPV4}" \
	-v SBI_BINDING_PORT="${SBI_BINDING_PORT:-8000}" \
	-v NRF_URI="http://${NRF}" \
	-v NRF_PEM="${NRF_PEM:-cert/nrf.pem}" \
	-v BILLING_IP="${BILLING_IP}" \
	-v BILLING_ENABLE="${BILLING_ENABLE:-true}" \
	-v CHF_NAME="${CHF_NAME:-CHF}" \
	-v CHF_PEM="${CHF_PEM:-cert/chf.pem}" \
	-v CHF_KEY="${CHF_KEY:-cert/chf.key}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v LOG_ENABLE="${LOG_ENABLE:-true}" \
	-v LOG_REPORT_CALLER="${LOG_REPORT_CALLER:-false}" \
	'{
		sub(/%MONGO_HOST/, MONGO_HOST);
		sub(/%MONGO_PORT/, MONGO_PORT);
		sub(/%MONGO_NAME/, MONGO_NAME);
		sub(/%SBI_REGISTER_IPV4/, SBI_REGISTER_IPV4);
		sub(/%SBI_BINDING_IPV4/, SBI_BINDING_IPV4);
		sub(/%SBI_BINDING_PORT/, SBI_BINDING_PORT);
		sub(/%NRF_URI/, NRF_URI);
		sub(/%NRF_PEM/, NRF_PEM);
		sub(/%BILLING_ENABLE/, BILLING_ENABLE);
		sub(/%BILLING_IP/, BILLING_IP);
		sub(/%CHF_NAME/, CHF_NAME);
		sub(/%CHF_PEM/, CHF_PEM);
		sub(/%CHF_KEY/, CHF_KEY);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%LOG_ENABLE/, LOG_ENABLE);
		sub(/%LOG_REPORT_CALLER/, LOG_REPORT_CALLER);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
