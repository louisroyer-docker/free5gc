# Copyright Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.21 AS builder
# backport branch (1.2.7)
#ARG COMMIT=a6b583ca8d01deaa03cd64e2a16c06aad97f62b0
# fix-ue-ip-addr-downlink branch (1.3.0)
ARG COMMIT=b50f12270acb851c5e09cd8240a7a81f4a2329c2
#RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install \
#    -ldflags="-X github.com/free5gc/util/version.VERSION=https://github.com/louisroyer-docker/free5gc -X github.com/free5gc/util/version.BUILD_TIME= -X github.com/free5gc/util/version.COMMIT_HASH=${COMMIT} -X github.com/free5gc/util/version.COMMIT_TIME=" \
#    github.com/free5gc/smf/cmd@${COMMIT}
RUN : ${COMMIT:? Missing build-arg COMMIT.} &&  git -C /go/src clone --depth 1 --quiet -b fix-ue-ip-addr-downlink https://github.com/louisroyer/free5gc-smf smf
WORKDIR /go/src/smf
RUN mkdir -p /go/bin && go build -o /go/bin/cmd \
     -ldflags="-X github.com/free5gc/util/version.VERSION=https://github.com/louisroyer-docker/free5gc -X github.com/free5gc/util/version.BUILD_TIME= -X github.com/free5gc/util/version.COMMIT_HASH=${COMMIT} -X github.com/free5gc/util/version.COMMIT_TIME=" cmd/main.go


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
