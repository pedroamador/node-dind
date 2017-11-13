FROM docker:rc-dind

LABEL maintainer Maurice Domínguez <maurice.ronet.dominguez@gmail.com>

ENV NODE_VER=8.5.0 \
    NPM_VER=5

RUN apk -U add curl git bash make gcc g++ python py-pip linux-headers paxctl libgcc libstdc++ binutils-gold ca-certificates \
 && cd /tmp \
 && curl --silent --ssl https://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}.tar.gz | tar zxf - \
 && cd node-v${NODE_VER} \
 && ./configure --prefix=/usr \
 && make -j1 && make install \
 && paxctl -cm /usr/bin/node \
 && npm install -g npm@${NPM_VER} \
 && find /usr/lib/node_modules/npm -name test -o -name .bin -type d \
 | xargs rm -rf \
 && apk del \
    binutils-gold \
    ca-certificates \
    gcc \
    g++ \
    linux-headers \
    make \
    paxctl \
    python \
 && rm -rf \
    /tmp/* \
    /var/cache/apk/* \
    /root/.npm \
    /root/.node-gyp \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    /usr/share/man

RUN pip install docker-compose