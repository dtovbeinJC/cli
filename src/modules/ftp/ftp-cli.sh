#!/bin/bash

#==============================================================================
#author         :Dan Tovbein (https://github.com/dtovbeinJC)
#title          :CFG2 Automation Program
#notes          :See app-cli.md for documentation
#version        :1.0.0
#bash_version   :GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin16)
#==============================================================================

function setFtpUser {
    ask "Write FTP username: "
    read USERNAME

    while [[ "${USERNAME}" == "" ]]; do
        printWarning  "Cannot set empty username"
        ask "Write FTP username again: "
        read USERNAME
    done

    touch ./.env-temp
    while read LINE; do
        if ! [[ ${LINE%%=*} = "FTP_USERNAME" ]];
        then
            eval echo "${LINE%%=*}=${LINE##*=} >> ./.env-temp"
        fi
    done < "./.env"

    eval echo "FTP_USERNAME=${USERNAME} >> ./.env-temp"
    rm -rf ./.env
    mv ./.env-temp ./.env
    source ./.env
}

function updateToFTP {
    echo "${COLOR_MAGENTA_1}Uploading version ${APP_VERSION} to FTP."
    printNotificationMessage "Do not close this window. This process takes around 5 minutes"
    scp -r ./builds/v${APP_VERSION}/* ${FTP_USERNAME}@${FTP_IP}:${FTP_DIR_PATH}

    local status=$?

    if [[ status -eq 0 ]];
    then
        printSuccessMessage "${APP_NAME} has been successfully uploaded to FTP."
    else
        printError "Could not update to FTP"
    fi
}


function initFtpProgram {
    echo ${BACKGROUND_COLOR_GREEN_2}${COLOR_BLACK_1}"  FTP                               "${RESET_COLOR}
    echo ${COLOR_GREEN_4}"[1]  Set up user"
    echo ${RESET_COLOR}"[0]  Back to main menu"

    ask ${COLOR_PINK_1}"Select task: "${RESET_COLOR}
    read TASK

    case "$TASK" in
    '1')
        setFtpUser
    ;;
    '0')
        ${1}
    ;;
    *)
        taskNotAvailable initFtpProgram
    ;;
    esac
}