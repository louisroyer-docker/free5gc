# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.21 AS builder
ARG COMMIT=05c55bbb9c052e670a27fda03335da660bc5636f
RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install github.com/free5gc/smf/cmd@${COMMIT}


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

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENV ROUTING_SCRIPT="docker-setup"

COPY ./template-script.sh /usr/local/bin/template-script.sh
ENV TEMPLATE_SCRIPT="template-script.sh"
ENV TEMPLATE_SCRIPT_ARGS=""

COPY ./template-smf.yaml /etc/free5gc/template-smf.yaml
ENV CONFIG_FILE="/etc/free5gc/smf.yaml"
ENV CONFIG_TEMPLATE="/etc/free5gc/template-smf.yaml"

# uerouting: ulcl disabled
# COPY ./template-smf-uerouting.yaml /etc/free5gc/template-smf-uerouting.yaml
# ENV CONFIG_FILE_UEROUTING="/etc/free5gc/smf.yaml"
# ENV CONFIG_TEMPLATE_UEROUTING="/etc/free5gc/template-smf.yaml"


ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
