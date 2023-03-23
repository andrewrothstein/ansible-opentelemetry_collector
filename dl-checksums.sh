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
    local shasum=$(grep $file $lchecksums | awk '{print $1}')
    if [ ! -z $shasum ];
    then
        printf "        # %s\n" $url
        printf "        %s: sha256:%s\n" $platform $shasum
    fi
}

dlappvers() {
    local lchecksums=$1
    local ver=$2
    local app=$3

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

    local lchecksums=$DIR/opentelemetry-collector-releases_checksums_${ver}.txt
    # https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.50.0/opentelemetry-collector-releases_checksums.txt
    local url=$MIRROR/v${ver}/opentelemetry-collector-releases_checksums.txt
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dlappvers $lchecksums $ver otelcol
    dlappvers $lchecksums $ver otelcol-contrib
}

dl_ver ${1:-0.74.0}
