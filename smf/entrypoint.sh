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
savedargs=( "$@" )
config_opt=1
uerouting_opt=1
while [ $# -gt 0 ]; do
	if [[ $1 == "--config" || $1 == "-c" ]]; then
		config_opt=0
	fi
	if [[ $1 == "--uerouting" || $1 == "-u" ]]; then
		uerouting_opt=0
	fi
	shift
done
set -- "${savedargs[@]}"

if  [[ -n "${CONFIG_TEMPLATE}" && -n "${CONFIG_FILE}" ]]; then
	if [ -n "${TEMPLATE_SCRIPT}" ]; then
		echo "[$(date --iso-8601=s)] Running ${TEMPLATE_SCRIPT}${TEMPLATE_SCRIPT_ARGS:+ }${TEMPLATE_SCRIPT_ARGS} for building ${CONFIG_FILE} from ${CONFIG_TEMPLATE}." > /dev/stderr
		"$TEMPLATE_SCRIPT" "$TEMPLATE_SCRIPT_ARGS"
	fi
else
	config_opt=0
fi

if  [[ -n "${CONFIG_TEMPLATE_UEROUTING}" && -n "${CONFIG_FILE_UEROUTING}" ]]; then
	if [ -n "${TEMPLATE_SCRIPT_UEROUTING}" ]; then
		echo "[$(date --iso-8601=s)] Running ${TEMPLATE_SCRIPT_UEROUTING}${TEMPLATE_SCRIPT_UEROUTING_ARGS:+ }${TEMPLATE_SCRIPT_UEROUTING_ARGS} for building ${CONFIG_FILE_UEROUTING} from ${CONFIG_TEMPLATE_UEROUTING}." > /dev/stderr
		"$TEMPLATE_SCRIPT_UEROUTING" "$TEMPLATE_SCRIPT_UEROUTING_ARGS"
	fi
else
	uerouting_opt=0
fi

if [ -n "${ROUTING_SCRIPT}" ]; then
	"${ROUTING_SCRIPT}"
fi

if [[ $config_opt -eq 1 ]] && [[ $uerouting_opt -eq 1 ]] ; then
	exec smf --config "$CONFIG_FILE" --uerouting "$CONFIG_FILE_UEROUTING" "$@"
elif [[ $config_opt -eq 1 ]]; then
	exec smf --config "$CONFIG_FILE" "$@"
elif [[ $uerouting_opt -eq 1 ]]; then
	exec smf --uerouting "$CONFIG_FILE_UEROUTING" "$@"
else
	exec smf "$@"
fi
