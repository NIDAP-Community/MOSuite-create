# hash:sha256:eaf9d65a12b71184eb3dfb71dc133669318c0d8295e3c3db8e46c4a3c9b9f3e7
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/mosuite-minimal:v0.4.0

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-ask-pass /

COPY postInstall /
RUN --mount=type=secret,id=secrets . /run/secrets/secrets \
    && /postInstall
