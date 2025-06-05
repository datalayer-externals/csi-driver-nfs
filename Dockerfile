# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM registry.k8s.io/build-image/debian-base:bookworm-v1.0.4

ARG ARCH
ARG binary=./bin/${ARCH}/nfsplugin
COPY ${binary} /nfsplugin

RUN apt update && apt upgrade -y && apt-mark unhold libcap2 && clean-install ca-certificates mount nfs-common sshfs netbase

RUN sed -i'' -e's/^NEED_STATD=$/NEED_STATD="yes"/' /etc/default/nfs-common

RUN mkdir /root/.ssh
COPY ssh/datalayer-jump /root/.ssh/id_rsa
COPY ssh/datalayer-jump.pub /root/.ssh/id_rsa.pub
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/id_rsa
RUN chown -R root:root /root/.ssh
RUN chmod 700 /root/.ssh

RUN mkdir -p /etc/ssh/sshd_config.d
RUN echo "Port 2223" >> /etc/ssh/sshd_config.d/port.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
