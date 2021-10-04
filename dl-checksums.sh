#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/open-telemetry/opentelemetry-collector/releases/download

# https://github.com/open-telemetry/opentelemetry-collector/releases/download/v0.33.0/otelcol_linux_amd64

dl() {
    local ver=$1
    local app=$2
    local lchecksums=$3
    local os=$4
    local arch=$5
    local dotexe=${6:-}
    local platform="${os}_${arch}"
    local file="${app}_${platform}${dotexe}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local app=$2
    # https://github.com/open-telemetry/opentelemetry-collector/releases/download/v0.33.0/checksums.txt
    local url="$MIRROR/v$ver/checksums.txt"
    local lchecksums="$DIR/${app}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $app $lchecksums darwin amd64
    dl $ver $app $lchecksums darwin arm64
    dl $ver $app $lchecksums linux amd64
    dl $ver $app $lchecksums linux arm64
    dl $ver $app $lchecksums windows amd64 .exe
}

dl_ver ${1:-0.33.0} otelcol
