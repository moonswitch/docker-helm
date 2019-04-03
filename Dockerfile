FROM alpine:3.8

ARG VERSION=2.12.1

ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV TAR_FILE="helm-v${VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache curl ca-certificates git openssh bash && \
    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64 && \
    rm -f /var/cache/apk/*

RUN git clone https://github.com/sstarcher/helm-release

RUN helm init --client-only --skip-refresh && \
    helm plugin install https://static.moonswitch.com/helm-release/helm-release_0.2.0_linux_amd64.tar.gz && \
    helm plugin install https://github.com/chartmuseum/helm-push --version 0.7.1

CMD ["helm"]