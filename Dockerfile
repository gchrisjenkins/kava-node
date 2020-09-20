FROM golang:1.15

LABEL Maintainer = "Chris Jenkins <g.chris.jenkins@gmail.com>"
LABEL Description="Docker image for Kava node"
LABEL License="MIT License"

ARG GIT_REPO_URL=https://github.com/Kava-Labs/kava.git

ENV KAVA_VERSION v0.9.1
ENV MONIKER "kava-test-node"

ENV TEST_PASSWORD "01234567"

RUN apt update && apt install -y git moreutils jq

RUN cd / && git clone -q ${GIT_REPO_URL} kava \
&& cd kava && git checkout -q ${KAVA_VERSION} \
&& make install

COPY ./bin/*.sh /usr/local/bin/

RUN set -ex \
&& chmod +x /usr/local/bin/*.sh

ENTRYPOINT ["entrypoint.sh"]