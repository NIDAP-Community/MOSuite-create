# hash:sha256:c9b112f3e66624a69cb708be33c863924c2212d60390363252f0db810ff49f7f
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/mosuite:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-askpass /

ARG RCACHE_OPTIONS
RUN echo $RCACHE_OPTIONS >> $(Rscript -e 'cat(R.home())')/etc/Rprofile.site
RUN Rscript -e 'remotes::install_version("argparse", "2.3.1")' \
    && Rscript -e 'remotes::install_version("remotes", "2.5.0")'

COPY postInstall /
RUN --mount=type=secret,id=secrets . /run/secrets/secrets \
    && /postInstall
