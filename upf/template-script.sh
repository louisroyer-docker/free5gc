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

if [ -z "$N4" ]; then
	echo "Missing mandatory environment variable (N4)." > /dev/stderr
	exit 1
fi
if [ -z "$DNN_LIST" ]; then
	echo "Missing mandatory environment variable (DNN_LIST)." > /dev/stderr
	exit 1
fi
if [ -z "$IF_LIST" ]; then
	echo "Missing mandatory environment variable (IF_LIST)." > /dev/stderr
	exit 1
fi

IFS=$'\n'
DNN_LIST_SUB=""
for DNN in ${DNN_LIST}; do
	if [ -n "${DNN}" ]; then
		DNN_LIST_SUB="${DNN_LIST_SUB}\n  ${DNN}"
	fi
done
IF_LIST_SUB=""
for INTERFACE in ${IF_LIST}; do
	if [ -n "${INTERFACE}" ]; then
		IF_LIST_SUB="${IF_LIST_SUB}\n    ${INTERFACE}"
	fi
done


awk \
	-v N4="${N4}" \
	-v DNN_LIST="${DNN_LIST_SUB}" \
	-v IF_LIST="${IF_LIST_SUB}" \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v LOG_ENABLE="${LOG_ENABLE:-true}" \
	-v LOG_REPORT_CALLER="${LOG_REPORT_CALLER:-false}" \
	'{
		sub(/%N4/, N4);
		sub(/%DNN_LIST/, DNN_LIST);
		sub(/%IF_LIST/, IF_LIST);
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%LOG_ENABLE/, LOG_ENABLE);
		sub(/%LOG_REPORT_CALLER/, LOG_REPORT_CALLER);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
