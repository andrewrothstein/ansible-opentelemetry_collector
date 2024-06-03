#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download

dl() {
    local lchecksums=$1
    local ver=$2
    local app=$3
    local os=$4
    local arch=$5
    local archive_type=${6:-tar.gz}
    local platform="${os}_${arch}"
    local file="${app}_${ver}_${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    local shasum=$(egrep -e "$file\$" $lchecksums | awk '{print $1}')
    if [ ! -z "$shasum" ];
    then
        printf "      # %s\n" $url
        printf "      %s: sha256:%s\n" "$platform" "$shasum"
    fi
}

dlappvers() {
    local ver=$1
    local app=$2

    # https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.101.0/opentelemetry-collector-releases_otelcol_checksums.txt
    # https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.101.0/opentelemetry-collector-releases_otelcol-contrib_checksums.txt
    local lchecksums="${DIR}/opentelemetry-collector-releases_${app}_checksums_${ver}.txt"
    local url="${MIRROR}/v${ver}/opentelemetry-collector-releases_${app}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "    # %s\n" $url
    printf "    %s:\n" $app
    dl $lchecksums $ver $app darwin amd64
    dl $lchecksums $ver $app darwin arm64
    dl $lchecksums $ver $app linux 386
    dl $lchecksums $ver $app linux amd64
    dl $lchecksums $ver $app linux arm64
    dl $lchecksums $ver $app windows 386
    dl $lchecksums $ver $app windows amd64
}

dl_ver() {
    local ver=$1
    printf "  '%s':\n" $ver
    dlappvers $ver otelcol
    dlappvers $ver otelcol-contrib
}

dl_ver ${1:-0.101.0}
