# Copyright Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.21 AS builder
# NOTE: 68354b63c8db7b0ee324139bab77d35dc796dcc9 is v1.3.0, but this tag has already been used previously
# See https://github.com/free5gc/free5gc/issues/653
#ARG COMMIT=v1.2.5
ARG COMMIT=68354b63c8db7b0ee324139bab77d35dc796dcc9
#RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install \
#    -ldflags="-X github.com/free5gc/util/version.VERSION=https://github.com/louisroyer-docker/free5gc -X github.com/free5gc/util/version.BUILD_TIME= -X github.com/free5gc/util/version.COMMIT_HASH=${COMMIT} -X github.com/free5gc/util/version.COMMIT_TIME=" \
#    github.com/free5gc/udm/cmd@${COMMIT}
RUN : ${COMMIT:? Missing build-arg COMMIT.} &&  git -C /go/src clone --depth 1 --quiet -b main https://github.com/free5gc/udm udm
WORKDIR /go/src/udm
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

COPY --from=builder /go/bin/cmd /usr/local/bin/udm
COPY ./*.sh /usr/local/bin/
COPY ./template-udm.yaml /usr/local/share/free5gc/

ENV ROUTING_SCRIPT="docker-setup" \
    ONESHOT="true" \
    TEMPLATE_SCRIPT="template-script.sh" \
    TEMPLATE_SCRIPT_ARGS="" \
    CONFIG_FILE="/etc/free5gc/udm.yaml" \
    CONFIG_TEMPLATE="/usr/local/share/free5gc/template-udm.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
