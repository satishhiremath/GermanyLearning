#!/bin/sh

ISO_NAME="CUSTOMIZED_UBUNTU"
BUILD_DIR=./build
OUTPUT_DIR=./out
OUTPUT_ISO=bmwadp.iso
#OS_ARCH=amd64
OS_ARCH=i386
OS_VER=16.04.4
SRC_ISO=ubuntu-${OS_VER}-desktop-${OS_ARCH}.iso
URL_SRC=http://releases.ubuntu.com/${OS_VER}

echo "+-------------------------------------------+"
echo "|            UBUNTU ISO MAKER               |"
echo "+-------------------------------------------+"

sudo apt --assume-yes install wget mkisofs

echo "Use build directory: ${BUILD_DIR}"
mkdir -p ${BUILD_DIR}

echo "Use ISO-file: ${SRC_ISO}"
if [ ! -f ${BUILD_DIR}/${SRC_ISO} ]; then
    echo "Download ISO-file: ${URL_SRC}/${SRC_ISO}"
    wget ${URL_SRC}/${SRC_ISO}
    #wget ${URL_SRC}/SHA1SUMS
    #wget ${URL_SRC}/SHA256SUMS
    wget ${URL_SRC}/MD5SUMS
    echo "== Downloaded MD5SUMS checksum"
    md5sum ${SRC_ISO}
    echo "== checked checsum for MD5SUM File"
    md5sum -c MD5SUMS
else
    echo "ISO-file already exists"
fi;

echo "== checking for ISO file"

if [ ! -f ${BUILD_DIR}/${SRC_ISO} ]; then
    echo "Error: ISO-file not found"
    exit 0
fi;
echo "== ISO file found"

mkdir ${BUILD_DIR}/iso
echo "== ISO folder Created under Build directory"
sudo mount -r -o loop ${BUILD_DIR}/${SRC_ISO} ${BUILD_DIR}/iso
echo "== mount iso on build/iso successful"
mkdir -p ${BUILD_DIR}/extracted
echo "== successfully created extracted folder under build folder"
cp -rT ${BUILD_DIR}/iso ${BUILD_DIR}/extracted
echo "== successfully copied build/iso to build/extracted"
sudo umount ${BUILD_DIR}/iso
echo "== unmounted build/iso"
rm -rf ${BUILD_DIR}/iso
echo "== build/iso removed"

###############################################
#
# Do your magic here
#
###############################################
echo "== making iso image out of extracted data"
mkisofs -D -r -V ${ISO_NAME} \
    -cache-inodes -J -l \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -input-charset utf-8 \
    -cache-inodes \
    -quiet \
    -o ${BUILD_DIR}/${OUTPUT_ISO} \
    ${BUILD_DIR}/extracted/

echo "== iso successfully created"

rm -rf ${BUILD_DIR}/extracted

echo "== Finished creating ISO"
