#!/bin/bash
set -u
clear
echo “”
echo “”
echo "$(basename $0)"
echo “”
echo “”
echo "################################################################################"
echo "################################################################################"
echo "################################################################################"
echo "############################### build openssl ##################################"
echo "############################### build openssl ##################################"
echo "############################### build openssl ##################################"
echo "############################### build openssl ##################################"
echo "############################### build openssl ##################################"
echo "############################### build openssl ##################################"
echo "################################################################################"
echo "################################################################################"
echo "################################################################################"
SH_DIR=${PWD}
OPENSSL_COMPRESSED_FN="openssl-1.0.2n.tar.gz"
OPENSSL_SRC_DIR=${OPENSSL_COMPRESSED_FN//.tar*/}
OPENSSL_BUILD_DIR=${SH_DIR}/xcode-build-${OPENSSL_SRC_DIR}
OPENSSL_BUILD_LOG_DIR=${OPENSSL_BUILD_DIR}/log
OPENSSL_BUILD_UNIVERSAL_DIR=${OPENSSL_BUILD_DIR}/universal
OPENSSL_UNIVERSAL_LIB_DIR=${OPENSSL_BUILD_UNIVERSAL_DIR}/lib

#rm -rf ${OPENSSL_SRC_DIR}
rm -rf ${OPENSSL_BUILD_DIR}

#tar xfz ${OPENSSL_COMPRESSED_FN} || exit 1

if [ ! -d "${OPENSSL_BUILD_UNIVERSAL_DIR}" ]; then
    mkdir -p "${OPENSSL_BUILD_UNIVERSAL_DIR}"
fi

if [ ! -d "${OPENSSL_BUILD_LOG_DIR}" ]; then
    mkdir "${OPENSSL_BUILD_LOG_DIR}"
fi

if [ ! -d "${OPENSSL_UNIVERSAL_LIB_DIR}" ]; then
    mkdir "${OPENSSL_UNIVERSAL_LIB_DIR}"
fi


pushd .
cd ${OPENSSL_SRC_DIR}
chmod +x ./Configure
CLANG=$(xcrun --find clang)

IPHONE_OS_SDK_PATH=$(xcrun -sdk iphoneos --show-sdk-path)
IPHONE_OS_CROSS_TOP=${IPHONE_OS_SDK_PATH//\/SDKs*/}
IPHONE_OS_CROSS_SDK=${IPHONE_OS_SDK_PATH##*/}

IPHONE_SIMULATOR_SDK_PATH=$(xcrun -sdk iphonesimulator --show-sdk-path)
IPHONE_SIMULATOR_CROSS_TOP=${IPHONE_SIMULATOR_SDK_PATH//\/SDKs*/}
IPHONE_SIMULATOR_CROSS_SDK=${IPHONE_SIMULATOR_SDK_PATH##*/}

ARCH_LIST=("armv7" "armv7s" "arm64" "i386" "x86_64")
ARCH_COUNT=${#ARCH_LIST[@]}
CROSS_TOP_LIST=(${IPHONE_OS_CROSS_TOP} ${IPHONE_OS_CROSS_TOP} ${IPHONE_OS_CROSS_TOP} ${IPHONE_SIMULATOR_CROSS_TOP} ${IPHONE_SIMULATOR_CROSS_TOP})
CROSS_SDK_LIST=(${IPHONE_OS_CROSS_SDK} ${IPHONE_OS_CROSS_SDK} ${IPHONE_OS_CROSS_SDK} ${IPHONE_SIMULATOR_CROSS_SDK} ${IPHONE_SIMULATOR_CROSS_SDK})

openssl_config_make()
{
ARCH=$1;
export CROSS_TOP=$2
export CROSS_SDK=$3
#export CC="${CLANG} -arch ${ARCH} -miphoneos-version-min=6.0 -fembed-bitcode"
export CC="${CLANG} -arch ${ARCH} -miphoneos-version-min=9.0"

make clean &> ${OPENSSL_BUILD_LOG_DIR}/make_clean.log

echo "configure for openssl ${ARCH}..."

if [ "x86_64" == ${ARCH} ]; then
    ./Configure iphoneos-cross --prefix=${OPENSSL_BUILD_DIR}/${ARCH} no-asm &> ${OPENSSL_BUILD_LOG_DIR}/${ARCH}-conf.log
else
    ./Configure iphoneos-cross --prefix=${OPENSSL_BUILD_DIR}/${ARCH} &> ${OPENSSL_BUILD_LOG_DIR}/${ARCH}-conf.log
fi

echo "build for openssl ${ARCH} output at ${OPENSSL_BUILD_DIR}/${ARCH}"
make &> ${OPENSSL_BUILD_LOG_DIR}/${ARCH}-make.log
make install_sw &> ${OPENSSL_BUILD_LOG_DIR}/${ARCH}-make-install.log

unset CC
unset CROSS_SDK
unset CROSS_TOP

echo -e "\n"
}

for ((i=0; i < ${ARCH_COUNT}; i++))
do
openssl_config_make ${ARCH_LIST[i]} ${CROSS_TOP_LIST[i]} ${CROSS_SDK_LIST[i]}
done

openssl_create_lib()
{
LIB_SRC=lib/$1
LIB_DST=${OPENSSL_UNIVERSAL_LIB_DIR}/$1
LIB_PATHS=( ${ARCH_LIST[@]/#/${OPENSSL_BUILD_DIR}/} )
LIB_PATHS=( ${LIB_PATHS[@]/%//${LIB_SRC}} )
lipo ${LIB_PATHS[@]} -create -output ${LIB_DST}
}
openssl_create_lib "libssl.a"
openssl_create_lib "libcrypto.a"

cp -R ${OPENSSL_BUILD_DIR}/${ARCH_LIST[0]}/include ${OPENSSL_BUILD_UNIVERSAL_DIR}

# popd

#rm -rf ${OPENSSL_SRC_DIR}

echo "done.${OPENSSL_BUILD_DIR}"

echo "################################################################################"
echo "################################################################################"
echo "################################################################################"
echo "######################### build curl with openssl ##############################"
echo "######################### build curl with openssl ##############################"
echo "######################### build curl with openssl ##############################"
echo "######################### build curl with openssl ##############################"
echo "######################### build curl with openssl ##############################"
echo "######################### build curl with openssl ##############################"
echo "################################################################################"
echo "################################################################################"
echo "################################################################################"

cd ${SH_DIR}
echo "PWD = ${PWD}"
ls -a -l
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
CURL_BUILD_DIR=${SH_DIR}/xcode-build-${CURL_SRC_DIR}-with-${OPENSSL_SRC_DIR}
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

# pushd .
cd ${CURL_SRC_DIR}
chmod +x ./configure
chmod +x ./buildconf
chmod +x ./compile
chmod +x ./install-sh
chmod +x ./libtool
chmod +x ./MacOSX-Framework

GCC=$(xcrun --find gcc)
export CC="${GCC}"

IPHONE_OS_SDK_PATH=$(xcrun -sdk iphoneos --show-sdk-path)
IPHONE_SIMULATOR_SDK_PATH=$(xcrun -sdk iphonesimulator --show-sdk-path)

HOST_LIST=("armv7-apple-darwin" "armv7s-apple-darwin" "arm-apple-darwin" "i386-apple-darwin" "x86_64-apple-darwin")
IOS_SDK_PATH_LIST=(${IPHONE_OS_SDK_PATH} ${IPHONE_OS_SDK_PATH} ${IPHONE_OS_SDK_PATH} ${IPHONE_SIMULATOR_SDK_PATH} ${IPHONE_SIMULATOR_SDK_PATH})

curl_config_make()
{
ARCH=$1
HOST_VAL=$3
IOS_SDK_PATH=$2
#export CFLAGS="-arch ${ARCH} -isysroot ${IOS_SDK_PATH} -fembed-bitcode -miphoneos-version-min=6.0"
export CFLAGS="-arch ${ARCH} -isysroot ${IOS_SDK_PATH} -miphoneos-version-min=9.0"

make clean &> ${CURL_BUILD_LOG_DIR}/make_clean.log

echo "configure for curl ${ARCH} - with-ssl="${OPENSSL_BUILD_DIR}/${ARCH}""

#./configure --host=${HOST_VAL} --prefix=${CURL_BUILD_DIR}/${ARCH} --disable-shared --enable-static --disable-manual --disable-verbose --without-ldap --disable-ldap --enable-ipv6 --enable-threaded-resolver --with-zlib="${IOS_SDK_PATH}/usr" --without-ssl &> ${CURL_BUILD_LOG_DIR}/${ARCH}-conf.log
./configure --host=${HOST_VAL} --prefix=${CURL_BUILD_DIR}/${ARCH} --disable-shared --enable-static --disable-manual --disable-verbose --without-ldap --disable-ldap --enable-ipv6 --enable-threaded-resolver --with-zlib="${IOS_SDK_PATH}/usr" --with-ssl="${OPENSSL_BUILD_DIR}/${ARCH}" &> ${CURL_BUILD_LOG_DIR}/${ARCH}-conf.log

echo "build for curl ${ARCH} output at ${CURL_BUILD_DIR}/${ARCH}"
make &> ${CURL_BUILD_LOG_DIR}/${ARCH}-make.log
make install &> ${CURL_BUILD_LOG_DIR}/${ARCH}-make-install.log

unset CFLAGS

echo -e "\n"
}



curl_create_lib()
{
  LIB_PATHS=( ${ARCH_LIST[@]/#/${CURL_BUILD_DIR}/} )
  LIB_PATHS=( ${LIB_PATHS[@]/%//lib/libcurl.a} )
  lipo ${LIB_PATHS[@]} -create -output ${CURL_BUILD_UNIVERSAL_DIR}/libcurl.a
}

for ((i=0; i < ${ARCH_COUNT}; i++))
do
curl_config_make ${ARCH_LIST[i]} ${IOS_SDK_PATH_LIST[i]} ${HOST_LIST[i]}
done

unset CC

curl_create_lib

cp -R ${CURL_BUILD_DIR}/${ARCH_LIST[0]}/include/curl ${CURL_BUILD_UNIVERSAL_DIR}
#mv ${CURL_BUILD_UNIVERSAL_DIR}/curl/curl.h  ${CURL_BUILD_UNIVERSAL_DIR}/curl/curl-32.h
#cp ${CURL_BUILD_DIR}/arm64/include/curl/curl.h ${CURL_BUILD_UNIVERSAL_DIR}/curl/curl-64.h
#echo -e "#if defined(__LP64__) && __LP64__ \n#include \"curl-64.h\" \n#else \n#include \"curl-32.h\" \n#endif" &> ${CURL_BUILD_UNIVERSAL_DIR}/curl/curl.h

cp -R ${OPENSSL_BUILD_UNIVERSAL_DIR}/include/openssl ${CURL_BUILD_UNIVERSAL_DIR}
popd

#rm -rf ${CURL_SRC_DIR}

echo "done.&{CURL_BUILD_DIR}"
