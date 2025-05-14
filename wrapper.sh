#!/bin/bash
# このファイルを適当なディレクトリにffmpegと置くことで、イメージが無ければ自動的にpullするようにできます。
# - イメージの更新日時が1週間以上経っている場合、強制的にイメージのプルを行います
IMAGE="ghcr.io/densuke/ffmpeg-docker:latest"

# イメージの確認処理
RESULT=$(docker images -q "${IMAGE}" 2> /dev/null)
if [[ "${RESULT}" == "" ]]; then
    docker pull "${IMAGE}"
else
    # イメージの更新日時を取得
    IMAGE_DATE=$(docker inspect --format='{{.Created}}' "${IMAGE}")
    IMAGE_DATE_SHORT=$(echo "${IMAGE_DATE}" | sed -E 's/\.[0-9]+Z$/Z/')
    # 現在の日付を取得
    CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    # 日付の差分を計算
    # macOSとLinux両対応で日付差分を計算
    if date --version >/dev/null 2>&1; then
        # GNU date (Linux)
        DIFF=$(( $(date -d "${CURRENT_DATE}" +%s) - $(date -d "${IMAGE_DATE}" +%s) ))
    else
        # BSD date (macOS)
        DIFF=$(( $(date -j -f "%Y-%m-%dT%H:%M:%SZ" "${CURRENT_DATE}" +%s) - $(date -j -f "%Y-%m-%dT%H:%M:%SZ" "${IMAGE_DATE_SHORT}" +%s) ))
    fi
    # 1週間以上経過している場合、イメージをプルする
    if [[ $((DIFF / (60 * 60 * 24))) -ge 7 ]]; then
        docker pull "${IMAGE}"
    fi
fi

docker run --rm -v "${PWD}:/app" -w /app "${IMAGE}" "$@"