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
mkdir -p "$(dirname "${CONFIG_FILE_UEROUTING}")"

if [ -z "$UEROUTING_INFO" ]; then
	echo "Missing mandatory environment variable (UEROUTING_INFO)." > /dev/stderr
	exit 1
fi


IFS=$'\n'
UEROUTING_INFO_SUB=""
for INFO in ${UEROUTING_INFO}; do
	if [ -n "${INFO}" ]; then
		UEROUTING_INFO_SUB="${UEROUTING_INFO_SUB}\n  ${INFO}"
	fi
done

awk \
	-v UEROUTING_INFO="${UEROUTING_INFO_SUB}" \
	'{
		sub(/%UEROUTING_INFO/, UEROUTING_INFO);
		print;
	}' \
	"${CONFIG_TEMPLATE_UEROUTING}" > "${CONFIG_FILE_UEROUTING}"
