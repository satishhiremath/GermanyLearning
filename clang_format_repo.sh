#!/usr/bin/env bash

# =============================================================================
# Copyright (C) 2017-2018, Bayerische Motoren Werke Aktiengesellschaft (BMW AG)
# =============================================================================

#set -eu

echo "Enter folder path to apply clang format. Else it will take present working directory!!!"
read toplevel

if [[ -z "$toplevel" ]]; then
    toplevel=$(pwd)
else
	if [ ! "$toplevel" ];then
        toplevel=$(pwd)
    else
        echo Invalid path entered!!\n
        exit 1
    fi
fi

find "${toplevel}" \
    -regex '.*\(\.c\|\.C\|\.cc\|\.cpp\|\.cxx\|\.h\|\.H\|\.hh\|\.hpp\|\.hxx\|\.cl\)$' \
    -printf "Processing %f...\n" \
    -exec clang-format-6.0 -i -style=file -fallback-style=none {} \;

echo "Formatting is completed"
