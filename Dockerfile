ARG ALPINE_VER="3.12"
FROM alpine:${ALPINE_VER}
LABEL maintainer="Ferdinand Prantl <prantlf@gmail.com>"

ARG ALPINE_VER="3.12"
ARG OPENRESTY_KEY="http://openresty.org/package/admin@openresty.com-5ea678a6.rsa.pub"
ARG OPENRESTY_REPO="http://openresty.org/package/alpine/v${ALPINE_VER}/main"

RUN wget -O "/etc/apk/keys/$(basename ${OPENRESTY_KEY})" "${OPENRESTY_KEY}" && \
    echo "${OPENRESTY_REPO}" >> /etc/apk/repositories && \
    apk --no-cache add openresty openresty-opm && \
    opm get spacewander/luafilesystem bungle/lua-resty-template && \
    apk del openresty-opm && \
    rm -r /root/.opmrc /root/.opm /usr/local/openresty/site/pod /usr/local/openresty/site/manifest
COPY . /

ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

STOPSIGNAL SIGQUIT
EXPOSE 80
VOLUME /app
WORKDIR /app
ENTRYPOINT ["openresty"]
