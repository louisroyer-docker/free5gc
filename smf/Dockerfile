# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.21 AS builder
ARG COMMIT=43a8cbe38ffd4ce5aaf47b0605125a029cff23a5
RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install \
    -ldflags="-X github.com/free5gc/util/version.VERSION=https://github.com/louisroyer-docker/free5gc -X github.com/free5gc/util/version.BUILD_TIME= -X github.com/free5gc/util/version.COMMIT_HASH=${COMMIT} -X github.com/free5gc/util/version.COMMIT_TIME=" \
    github.com/free5gc/smf/cmd@${COMMIT}


FROM louisroyer/base-irit:latest

LABEL maintainer="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.authors="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.source="https://github.com/louisroyer-docker/free5gc"

# Used to disable caching of next steps, if not build since 1 day,
# allowing to search and apply security upgrades
ARG BUILD_DATE=""

RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    docker-setup \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/cmd /usr/local/bin/smf
COPY ./*.sh /usr/local/bin/
COPY ./template-smf.yaml ./template-uerouting.yaml /usr/local/share/free5gc/
ENV ROUTING_SCRIPT="docker-setup" \
    ONESHOT="true" \
    TEMPLATE_SCRIPT="template-script.sh" \
    TEMPLATE_SCRIPT_ARGS="" \
    CONFIG_FILE="/etc/free5gc/smf.yaml" \
    CONFIG_TEMPLATE="/usr/local/share/free5gc/template-smf.yaml" \
    TEMPLATE_SCRIPT_UEROUTING="template-script-uerouting.sh" \
    TEMPLATE_SCRIPT_UEROUTING_ARGS="" \
    CONFIG_FILE_UEROUTING="/etc/free5gc/uerouting.yaml" \
    CONFIG_TEMPLATE_UEROUTING="/usr/local/share/free5gc/template-uerouting.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
