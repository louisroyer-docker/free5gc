#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
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
