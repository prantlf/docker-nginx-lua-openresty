ARG ALPINE_VER="3.12"
FROM prantlf/alpine-make-gcc:${ALPINE_VER} as builder

RUN cd /root && \
    wget https://github.com/aklomp/base64/archive/v0.4.0.tar.gz && \
    tar xf v0.4.0.tar.gz && rm v0.4.0.tar.gz && \
    cd base64-0.4.0 && \
    AVX2_CFLAGS=-mavx2 SSSE3_CFLAGS=-mssse3 SSE41_CFLAGS=-msse4.1 SSE42_CFLAGS=-msse4.2 AVX_CFLAGS=-mavx make lib/libbase64.o && \
    cc -std=c99 -O3 -Wall -Wextra -pedantic -shared lib/libbase64.o -o lib/libbase64.so && \
    cd .. && \
    apk --no-cache add pcre-dev && \
    wget https://github.com/iresty/lua-resty-libr3/archive/v1.2.tar.gz && \
    tar xf v1.2.tar.gz && rm v1.2.tar.gz && \
    cd lua-resty-libr3-1.2 && \
    wget https://github.com/c9s/r3/archive/2.0.zip && \
    unzip 2.0.zip && rm 2.0.zip && \
    mv r3-2.0 r3 && \
    cd r3 && \
    ./autogen.sh && ./configure && make && \
    cd .. && \
    make libr3.so && \
    cd .. && \
    mkdir -p usr/local/lib usr/local/openresty/lualib/resty && \
    cp base64-0.4.0/lib/libbase64.so usr/local/lib/ && \
    cp lua-resty-libr3-1.2/libr3.so usr/local/openresty/lualib/ && \
    cp lua-resty-libr3-1.2/lib/resty/*.lua usr/local/openresty/lualib/resty/

ARG ALPINE_VER="3.12"
FROM alpine:${ALPINE_VER}
LABEL maintainer="Ferdinand Prantl <prantlf@gmail.com>"

ARG ALPINE_VER="3.12"
ARG OPENRESTY_KEY="http://openresty.org/package/admin@openresty.com-5ea678a6.rsa.pub"
ARG OPENRESTY_REPO="http://openresty.org/package/alpine/v${ALPINE_VER}/main"

RUN wget -O "/etc/apk/keys/$(basename ${OPENRESTY_KEY})" "${OPENRESTY_KEY}" && \
    echo "${OPENRESTY_REPO}" >> /etc/apk/repositories && \
    apk --no-cache add openresty openresty-opm libuuid && \
    opm get spacewander/luafilesystem bungle/lua-resty-template jkeys089/lua-resty-hmac SkyLothar/lua-resty-jwt detailyang/lua-resty-cors && \
    apk del openresty-opm && \
    rm -r /root/.opmrc /root/.opm /usr/local/openresty/site/pod /usr/local/openresty/site/manifest && \
    wget -O /usr/local/openresty/lualib/resty/libbase64.lua https://raw.githubusercontent.com/bungle/lua-resty-libbase64/master/lib/resty/libbase64.lua && \
    wget -O /usr/local/openresty/lualib/resty/murmurhash2.lua https://raw.githubusercontent.com/bungle/lua-resty-murmurhash2/v1.0/lib/resty/murmurhash2.lua && \
    wget -O /usr/local/openresty/lualib/resty/random.lua https://raw.githubusercontent.com/bungle/lua-resty-random/master/lib/resty/random.lua && \
    wget -O /usr/local/openresty/lualib/resty/uuid.lua https://raw.githubusercontent.com/bungle/lua-resty-uuid/v1.1/lib/resty/uuid.lua
COPY --from=builder /root/usr /usr/
COPY . /

ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

STOPSIGNAL SIGQUIT
EXPOSE 80
VOLUME /app
WORKDIR /app
ENTRYPOINT ["openresty"]
