#!/usr/bin/env bash
set -o errexit
set -o nounset

# This script takes care of integrating Reveal Server into your iOS application target when you have already manually linked the XCFramework into your app.

# If the current build configuration as defined by the environment variable CONFIGURATION does not match the name provided by REVEAL_LOAD_FOR_CONFIGURATION (this defaults to "Debug"), then any copies of RevealServer that Xcode has copied into your application will be removed.

# NOTE: This script is intended to be run from within an Xcode run script build phase, and won't work without the environment variables provided therein.

# If you want to inspect your app using Reveal in build configurations that are not the default "Debug" configuration, override the REVEAL_LOAD_FOR_CONFIGURATION environment variable with the full name of your desired configuration.
load_trigger=${REVEAL_LOAD_FOR_CONFIGURATION:=Debug}

if [ "${PLATFORM_NAME}" == *simulator ]; then
    echo "Reveal Server not integrated into ${TARGET_NAME}: Targeted platform is simulated, and does not require it."
    exit 0
fi

if [ "${CONFIGURATION}" != "${load_trigger}" ]; then
    # If we are not running in the expected configuration, remove the RevealServer framework (which needs to have been weakly linked).
    bundled_reveal_server="${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/RevealServer.framework"

    if [ -e "${bundled_reveal_server}" ]; then
        rm -r "${bundled_reveal_server}"
    fi

    echo "Reveal Server has been removed from ${TARGET_NAME}: Current build configuration is not '${load_trigger}'."
    exit 0
fi

# Otherwise, we need to insert the NSBonjourServices array into the app's Info.plist. It's OK if this fails due to the key already existing.
plutil -insert NSBonjourServices -xml '<array/>' "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}" || true

# Insert Reveal's Bonjour details into the NSBonjourServices array.
plutil -insert NSBonjourServices.0 -string "_reveal._tcp" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"

echo "An NSBonjourServices entry for Reveal (_reveal._tcp) has been added to ${INFOPLIST_PATH}"

echo "Reveal Server has been successfully integrated into ${TARGET_NAME}."
