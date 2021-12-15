#!/bin/bash

##
## VARS
##

# USER-DEFINED
SYSTEM="linux"          # linux/freebsd/solaris/openbsd
SYSTEM_ARCH="amd64"     # 386/amd64/arm
DOWNLOAD_PATH="/home/$(whoami)/bin/terraform_archive"   # where to store ZIP archives
INSTALL_PATH="/home/$(whoami)/bin"                      # where to put executables (should be in PATH variable)

# GREPPED (DO NOT CHANGE)
TF_VERSION_LONG=$(grep required_version ./* 2>/dev/null | sort -r | awk -F'"' '{ print $2 }' | head -n 1)           # TF version + constraint
TF_FILE=$(grep required_version ./* 2>/dev/null | grep "$TF_VERSION_LONG" | awk -F':' '{ print $1 }' | head -n 1)   # file where version was found
TF_VERSION=$(echo $TF_VERSION_LONG | awk -F' ' '{ print $NF }')                             # TF version
TF_VERSION_CONSTRAINT=$(echo $TF_VERSION_LONG | awk -F' ' '{ print $1 }')                   # version constraint

##
##
##

if [ "$TF_VERSION" == "" ]; then
    echo "No 'required_version' specified - Nothing to do."
else
    if [ "$(echo '~>>=' | grep -w $TF_VERSION_CONSTRAINT)" != "" ] && \
            [ "$(echo $TF_VERSION_CONSTRAINT | wc -c)" == "3" ]; then
            TF_VERSION=$(curl https://releases.hashicorp.com/terraform/ | grep "$(echo $TF_VERSION | \
                    awk -F'.' '{ print $1 }').$(echo $TF_VERSION | awk -F'.' '{ print $2 }')".* | \
                    awk -F'_' '{ print $NF }' | awk -F'<' '{ print $1 }' | sort | grep -v - | tail -n1)
    fi
    echo -e "\nTF_VERSION:\tRequested:\t$TF_VERSION_LONG ($TF_FILE)"
    echo -e "\t\tDownloading:\t$TF_VERSION\n"
    mkdir -pv $DOWNLOAD_PATH
    if [ ! -f "$DOWNLOAD_PATH"/terraform_"$TF_VERSION"_"$SYSTEM"_"$SYSTEM_ARCH".zip ]; then
        cd $DOWNLOAD_PATH
        wget https://releases.hashicorp.com/terraform/"$TF_VERSION"/terraform_"$TF_VERSION"_"$SYSTEM"_"$SYSTEM_ARCH".zip
    fi
    mkdir -pv $INSTALL_PATH
    cd $INSTALL_PATH
    rm terraform
    unzip "$DOWNLOAD_PATH"/terraform_"$TF_VERSION"_"$SYSTEM"_"$SYSTEM_ARCH".zip
    chmod +x terraform
fi
