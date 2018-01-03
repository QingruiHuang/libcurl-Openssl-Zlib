#!/bin/bash

set -u
clear
echo “”
echo “”
echo $(basename $0)
echo “”
echo “”
CURL_SRC_DIR=""
UNCOMPRESSED_CMD=""
CURL_COMPRESSED_FN="curl-7.55.1.tar.bz2"

#MIME_TYPE=$(file ${CURL_COMPRESSED_FN} -b --mime-type) || exit 1

#if [ "application/zip" == "${MIME_TYPE}" ]; then
#    CURL_SRC_DIR=${CURL_COMPRESSED_FN//.zip*/}
#    UNCOMPRESSED_CMD="unzip -q ${CURL_COMPRESSED_FN} || exit 1"
#elif [ "application/x-gzip" == "${MIME_TYPE}" ]; then
#    CURL_SRC_DIR=${CURL_COMPRESSED_FN//.tar*/}
#    UNCOMPRESSED_CMD="tar xfz ${CURL_COMPRESSED_FN} || exit 1"
#elif [ "application/x-bzip2" == "${MIME_TYPE}" ]; then
#    CURL_SRC_DIR=${CURL_COMPRESSED_FN//.tar*/}
#    UNCOMPRESSED_CMD="tar jxf ${CURL_COMPRESSED_FN} || exit 1"
#else
#    echo "can't uncompress ${CURL_COMPRESSED_FN}"
#    exit 1
#fi

CURL_SRC_DIR=${CURL_COMPRESSED_FN//.tar*/}
CURL_BUILD_DIR=${PWD}/xcode-build-${CURL_SRC_DIR}
CURL_BUILD_LOG_DIR=${CURL_BUILD_DIR}/log
CURL_BUILD_UNIVERSAL_DIR=${CURL_BUILD_DIR}/universal

#rm -rf ${CURL_SRC_DIR}
rm -rf ${CURL_BUILD_DIR}
eval "${UNCOMPRESSED_CMD}"

if [ ! -d "${CURL_BUILD_UNIVERSAL_DIR}" ]; then
    mkdir -p "${CURL_BUILD_UNIVERSAL_DIR}"
fi

if [ ! -d "${CURL_BUILD_LOG_DIR}" ]; then
    mkdir "${CURL_BUILD_LOG_DIR}"
fi

pushd .
cd ${CURL_SRC_DIR}
chmod +x ./configure
chmod +x ./buildconf
chmod +x ./compile
chmod +x ./install-sh
chmod +x ./libtool
chmod +x ./ltmain.sh
chmod +x ./MacOSX-Framework

GCC=$(xcrun --find gcc)
export CC="${GCC}"

IPHONE_OS_SDK_PATH=$(xcrun -sdk iphoneos --show-sdk-path)
IPHONE_SIMULATOR_SDK_PATH=$(xcrun -sdk iphonesimulator --show-sdk-path)

ARCH_LIST=("armv7" "armv7s" "arm64" "i386" "x86_64")
ARCH_COUNT=${#ARCH_LIST[@]}
HOST_LIST=("armv7-apple-darwin" "armv7s-apple-darwin" "arm-apple-darwin" "i386-apple-darwin" "x86_64-apple-darwin")
IOS_SDK_PATH_LIST=(${IPHONE_OS_SDK_PATH} ${IPHONE_OS_SDK_PATH} ${IPHONE_OS_SDK_PATH} ${IPHONE_SIMULATOR_SDK_PATH} ${IPHONE_SIMULATOR_SDK_PATH})

config_make()
{
ARCH=$1
HOST_VAL=$3
IOS_SDK_PATH=$2
#export CFLAGS="-arch ${ARCH} -isysroot ${IOS_SDK_PATH} -fembed-bitcode -miphoneos-version-min=6.0"
export CFLAGS="-arch ${ARCH} -isysroot ${IOS_SDK_PATH} -miphoneos-version-min=9.0"

make clean &> ${CURL_BUILD_LOG_DIR}/make_clean.log

./configure --host=${HOST_VAL} --prefix=${CURL_BUILD_DIR}/${ARCH} --disable-shared --enable-static --disable-manual --disable-verbose --without-ldap --disable-ldap --enable-ipv6 --enable-threaded-resolver --with-zlib="${IOS_SDK_PATH}/usr" &> ${CURL_BUILD_LOG_DIR}/${ARCH}-conf.log

echo "build curl for ${ARCH}..."
make &> ${CURL_BUILD_LOG_DIR}/${ARCH}-make.log
make install &> ${CURL_BUILD_LOG_DIR}/${ARCH}-make-install.log

unset CFLAGS

echo -e "\n"
}

for ((i=0; i < ${ARCH_COUNT}; i++))
do
config_make ${ARCH_LIST[i]} ${IOS_SDK_PATH_LIST[i]} ${HOST_LIST[i]}
done

unset CC

LIB_PATHS=( ${ARCH_LIST[@]/#/${CURL_BUILD_DIR}/} )
LIB_PATHS=( ${LIB_PATHS[@]/%//lib/libcurl.a} )
lipo ${LIB_PATHS[@]} -create -output ${CURL_BUILD_UNIVERSAL_DIR}/libcurl.a

cp -R ${CURL_BUILD_DIR}/${ARCH_LIST[0]}/include/curl ${CURL_BUILD_UNIVERSAL_DIR}

popd

#rm -rf ${CURL_SRC_DIR}

echo "done."
