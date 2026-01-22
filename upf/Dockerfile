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

FROM golang:1.21 AS builder
ARG COMMIT_GTP5GNL=v1.6.0
RUN : ${COMMIT_GTP5GNL:? Missing build-arg COMMIT_GTP5GNL.} && go install \
    github.com/free5gc/go-gtp5gnl/cmd/gogtp5g-tunnel@${COMMIT_GTP5GNL}
ARG COMMIT=v1.2.6
RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install \
    -ldflags="-X github.com/free5gc/util/version.VERSION=https://github.com/louisroyer-docker/free5gc -X github.com/free5gc/util/version.BUILD_TIME= -X github.com/free5gc/util/version.COMMIT_HASH=${COMMIT} -X github.com/free5gc/util/version.COMMIT_TIME=" \
    github.com/free5gc/go-upf/cmd@${COMMIT}


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

COPY --from=builder /go/bin/gogtp5g-tunnel /usr/local/bin/gtp5g-tunnel
COPY --from=builder /go/bin/cmd /usr/local/bin/upf
COPY ./*.sh /usr/local/bin/
COPY ./template-upf.yaml /usr/local/share/free5gc/

ENV ROUTING_SCRIPT="docker-setup" \
    ONESHOT="true" \
    TEMPLATE_SCRIPT="template-script.sh" \
    TEMPLATE_SCRIPT_ARGS="" \
    CONFIG_FILE="/etc/free5gc/upf.yaml" \
    CONFIG_TEMPLATE="/usr/local/share/free5gc/template-upf.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
