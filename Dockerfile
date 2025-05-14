FROM alpine:3.21
# 作業用ユーザーの作成
ARG USER=worker
ARG UID=1000
ARG GID=1000

# hadolint ignore=DL3018
RUN apk add --no-cache ffmpeg

# ユーザーの作成
RUN addgroup -g ${GID} ${USER} \
    && adduser -u ${UID} -D -G ${USER} ${USER}

# 作業ディレクトリの作成
RUN mkdir -p /app \
    && chown -R ${USER}:${USER} /app
WORKDIR /app

USER ${USER}

ENTRYPOINT [ "ffmpeg" ]
