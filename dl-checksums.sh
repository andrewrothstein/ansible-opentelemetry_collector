#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download

dl() {
    local ver=$1
    local app=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="${app}_${ver}_${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    local lfile="${DIR}/${file}"
    if [ ! -e $lfile ];
    then
        curl -sSLf -o $lfile $url
    fi
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local app=${2:-otelcol}

    printf "  '%s':\n" $ver

    dl $ver $app darwin amd64
    dl $ver $app darwin arm64
    dl $ver $app linux 386
    dl $ver $app linux amd64
    dl $ver $app linux arm64
    dl $ver $app windows 386
    dl $ver $app windows amd64
}

dl_ver 0.40.0
dl_ver 0.41.0
dl_ver 0.42.0
dl_ver 0.43.0
dl_ver 0.44.0
dl_ver 0.45.0
dl_ver 0.46.0
dl_ver 0.47.0
dl_ver 0.48.0
dl_ver 0.49.0
dl_ver ${1:-0.50.0}
