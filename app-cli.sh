#!/bin/bash

#==============================================================================
#author         :Dan Tovbein (https://github.com/dtovbeinJC)
#title          :CFG2 Automation Program
#notes          :See app-cli.md for documentation
#version        :1.0.0
#bash_version   :GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin16)
#==============================================================================

alias app-cli="source cli/app-cli.sh"

declare RESET_COLOR=$(tput sgr0)
declare COLOR_BLACK_1=$(tput setaf 0)
declare BACKGROUND_COLOR_RED_1=$(tput setab 196)
declare BACKGROUND_COLOR_YELLOW_1=$(tput setab 3)
declare BACKGROUND_COLOR_GREEN_1=$(tput setab 2)
declare BACKGROUND_COLOR_GREEN_2=$(tput setab 119)
declare BACKGROUND_COLOR_BLUE_1=$(tput setab 12)
declare BACKGROUND_COLOR_LIGHT_BLUE_1=$(tput setab 045)
declare COLOR_LIGHT_BLUE_1=$(tput setaf 045)
declare BACKGROUND_COLOR_ORANGE_1=$(tput setab 220)
declare BACKGROUND_COLOR_ORANGE_2=$(tput setab 172)
declare BACKGROUND_COLOR_PINK_1=$(tput setab 197)
declare BACKGROUND_COLOR_CYAN_1=$(tput setab 6)
declare COLOR_PINK_1=$(tput setaf 197)
declare COLOR_PINK_2=$(tput setaf 210)
declare COLOR_RED_1=$(tput setaf 196)
declare COLOR_GREEN_1=$(tput setaf 2)
declare COLOR_GREEN_2=$(tput setaf 30)
declare COLOR_GREEN_3=$(tput setaf 29)
declare COLOR_GREEN_4=$(tput setaf 119)
declare COLOR_YELLOW_1=$(tput setaf 3)
declare COLOR_BLUE_1=$(tput setaf 4)
declare COLOR_BLUE_2=$(tput setaf 12)
declare COLOR_BLUE_3=$(tput setaf 20)
declare COLOR_BLUE_4=$(tput setaf 123)
declare COLOR_MAGENTA_1=$(tput setaf 5)
declare COLOR_CYAN_1=$(tput setaf 6)
declare COLOR_WHITE=$(tput setaf 15)
declare COLOR_GREY_1=$(tput setaf 7)
declare COLOR_GREY_2=$(tput setaf 239)
declare COLOR_ORANGE_1=$(tput setaf 220)
declare COLOR_ORANGE_2=$(tput setaf 172)
declare VALUE_COLOR=${COLOR_GREEN_1}
declare ERROR_COLOR=${COLOR_RED_1}
declare QUESTION_COLOR=${COLOR_BLUE_4}
declare SUCCESFUL_COLOR=${COLOR_GREEN_1}
declare WARNING_COLOR=${COLOR_ORANGE_1}
declare NOTIFICATION_COLOR=${COLOR_CYAN_1}
declare ENV_SETTINGS=${COLOR_MAGENTA_1}
declare APPLICATION_COLOR=${COLOR_LIGHT_BLUE_1}
declare SERVER_COLOR=${COLOR_LIGHT_BLUE_1}
declare APPLICATION_BACKGROUND_COLOR=${BACKGROUND_COLOR_LIGHT_BLUE_1}
declare SERVER_BACKGROUND_COLOR=${BACKGROUND_COLOR_PINK_1}

# FILES
declare APP_CLI_CONFIG_FILE="./.app-cli.config"
declare SASS_VARIABLES_CONFIG_FILE="./.sass-variables.config"
declare SASS_JS_VARIABLES="./src/sass/_variables.js"
declare SASS_VARIABLES="./src/sass/_variables.scss"

function setupConfigFile {
  if [ -f ${APP_CLI_CONFIG_FILE} ]; then
      rm -rf ${APP_CLI_CONFIG_FILE}
  fi
  touch ${APP_CLI_CONFIG_FILE}

  if [ -f ${SASS_VARIABLES_CONFIG_FILE} ]; then
      rm -rf ${SASS_VARIABLES_CONFIG_FILE}
  fi
  touch ${SASS_VARIABLES_CONFIG_FILE}

  ask "App name: "
  read APP_NAME
  echo "APP_NAME=""\"${APP_NAME}\"" >> ${APP_CLI_CONFIG_FILE}

  ask "Short name: "
  read APP_SHORT_NAME
  echo "APP_SHORT_NAME=""\"${APP_SHORT_NAME}\"" >> ${APP_CLI_CONFIG_FILE}

  ask "Server address (staging): " #https://staging-config.jamcity.com/1/staging/
  read SERVER_ADDRESS_STAGING
  echo "SERVER_ADDRESS_STAGING=""\"${SERVER_ADDRESS_STAGING}\"" >> ${APP_CLI_CONFIG_FILE}

  ask "Server address (production): " #https://config.jamcity.com/1/prod/
  read SERVER_ADDRESS_PRODUCTION
  echo "SERVER_ADDRESS_PRODUCTION=""\"${SERVER_ADDRESS_PRODUCTION}\"" >> ${APP_CLI_CONFIG_FILE}

  local EXAMPLES_COMPONENT_PATH="./cli/react/examples/"
  echo "EXAMPLES_COMPONENT_PATH=""\"${EXAMPLES_COMPONENT_PATH}\"" >> ${APP_CLI_CONFIG_FILE}
  local CONSTANTS_PATH="./src/constants/"
  echo "CONSTANTS_PATH=""\"${CONSTANTS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}

  local OUTPUT_UTILS_PATH="./src/utils/"
  echo "OUTPUT_UTILS_PATH=""\"${OUTPUT_UTILS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}
  local OUTPUT_REDUCERS_PATH="./src/reducers/"
  echo "OUTPUT_REDUCERS_PATH=""\"${OUTPUT_REDUCERS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}

  local ORIGIN_COMPONENTS_PATH="./cli/react/examples/components/"
  echo "ORIGIN_COMPONENTS_PATH=""\"${ORIGIN_COMPONENTS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}
  local OUTPUT_COMPONENTS_PATH="./src/components/"
  echo "OUTPUT_COMPONENTS_PATH=""\"${OUTPUT_COMPONENTS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}

  local ORIGIN_CONTAINERS_PATH="./cli/react/examples/containers/"
  echo "ORIGIN_CONTAINERS_PATH=""\"${ORIGIN_CONTAINERS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}
  local OUTPUT_CONTAINERS_PATH="./src/containers/"
  echo "OUTPUT_CONTAINERS_PATH=""\"${OUTPUT_CONTAINERS_PATH}\"" >> ${APP_CLI_CONFIG_FILE}

  source ${APP_CLI_CONFIG_FILE}

  setupBaseApp
  setEnvironment false
}

function showAppEnvs {
    source ./.env
    echo ""
    echo "${COLOR_MAGENTA_1}----------------------------------------------------------------"
    echo "${APP_NAME} envioronment ${COLOR_GREY_2} Current version: "${RESET_COLOR}${APP_VERSION}" "$(smileIcon)
    echo "${COLOR_MAGENTA_1}----------------------------------------------------------------${RESET_COLOR}"
    echo " Environment: "${VALUE_COLOR}${APP_ENV}${RESET_COLOR}

    echo " Server adress: "${VALUE_COLOR}${APP_SERVER_ADDRESS}${RESET_COLOR}
    echo " IP address: "${VALUE_COLOR}${FTP_IP}${RESET_COLOR}

    if [[ ${APP_ENV} = "staging" ]];
    then
        echo " Client ID: "${VALUE_COLOR}${CLIENT_ID_STAGING}${RESET_COLOR}
    fi

    if [[ ${APP_ENV} = "production" ]];
    then
        echo " Client ID: "${VALUE_COLOR}${CLIENT_ID_PRODUCTION}${RESET_COLOR}
    fi

    echo " FTP username: "${VALUE_COLOR}${FTP_USERNAME}${RESET_COLOR}
    echo "${COLOR_GREY_2}----------------------------------------------------------------${RESET_COLOR}"
}

function checkForEnv {
    local envFile="./.env"
    local envFileJs="./src/env.js"

    if [ -a ${envFile} ];
    then
        source ${envFile}
        getCurrentVersion
    else
        printError "File ${envFile} not found"
        touch ${envFile}
        setEnvironment false
    fi

    if ! [[ -a ${envFileJs} ]] && [[ -a ${envFile} ]];
    then
        compileEnvsToJavascript
    fi
}

function removeEnvs {
    local envFile="./.env"
    local envFileJs="./src/env.js"
    while read -r LINE; do
        if ! [ -z "$LINE" ]; then
            SOURCE_TO_FIND="="
            if echo "$LINE" | grep -q "$SOURCE_TO_FIND"; then
                local VAR_NAME=${LINE%%$SOURCE_TO_FIND*}
                local VAR_VALUE=${LINE##*$SOURCE_TO_FIND}
                eval `echo unset ${VAR_NAME}`
            else
                :
            fi
        fi
    done < ${envFile}

    eval `echo unset FTP_USERNAME`

    rm -rf ${envFile}
    rm -rf ${envFileJs}
    checkForEnv
}

function setAppEnvs {
    source ./app-cli.config

    case "${APP_ENV}" in
    staging)
        addVariableToEnv "APP_SERVER_ADDRESS" ${SERVER_ADDRESS_STAGING}
        addVariableToEnv "FTP_IP" ${FTP_IP_STAGING}
    ;;
    production)
        addVariableToEnv "APP_SERVER_ADDRESS" ${SERVER_ADDRESS_PRODUCTION}
        addVariableToEnv "FTP_IP" ${FTP_IP_PRODUCTION}
    esac
}

function setupVariablesFile {
    printNotificationMessage "Proccesing SASS variables ..."
    
    local sassJsVariables="./src/sass/_variables.js"
    local sassVariables="./src/sass/_variables.scss"
    
    if [ -f ${sassJsVariables} ];
    then
        rm -rf ${sassJsVariables}
    fi

    touch ${sassJsVariables}
    echo "// $(getAutogeneratedMessage)" >> ${sassJsVariables}    
    echo "// READ ONLY FILE, NOT EDITABLE!" >> ${sassJsVariables}

    if [ -f ${sassVariables} ];
    then
        rm -rf ${sassVariables}
    fi
    
    touch ${sassVariables}
    echo "/* $(getAutogeneratedMessage) */" >> ${sassVariables}
    echo "/* READ ONLY FILE, NOT EDITABLE! */" >> ${sassVariables}

    variableName=""
    variableValue=""
    variableType=""

    while read VARIABLE;
    do
        if [ -n "${VARIABLE}" ]; then
            variableType=${VARIABLE%%_*}
            variableName=${VARIABLE%%=*}            
            variableValue=${VARIABLE##*=}

          if [[ ${variableType} = "NUM" ]] || [[ ${variableType} = "STR" ]];
            then
                variableName=${variableName##*${variableType}_}
                export ${variableName}="${variableValue//\"}"

                _variableName=`echo "${variableName}" | tr '[:upper:]' '[:lower:]'`
                _variableName="${_variableName//_/-}"

                if [[ -z ${!variableValue} ]];
                then
                    eval echo "export const ${variableName} = '${variableValue};' >> ${sassJsVariables}"

                    if [[ ${variableType} = "NUM" ]];
                    then
                      eval echo "'\$'${_variableName}: '${variableValue//\"};' >> ${sassVariables}"
                    else
                      eval echo "'\$'${_variableName}: '${variableValue};' >> ${sassVariables}"
                    fi
                fi
            else
                  eval echo "export const ${variableName} = '"\""`echo ${!variableValue}`"\"";' >> ${sassJsVariables}"

                  _variableName=`echo "${variableName}" | tr '[:upper:]' '[:lower:]'`
                  _variableName="${_variableName//_/-}"
                  eval echo "'\$'${_variableName}: '`echo ${!variableValue}`;' >> ${sassVariables}"
            fi
        fi
    done < "./.sass-variables.config"

    printSuccessMessage "SASS variable has been updated"
}

function setDebugMode {
    addVariableToEnv "APP_DEBUG" "false"
}

function addVariableToEnv {
    touch ./.env-temp
    while read variable; do
        local variableName=${variable%%=*}
        local variableValue=${variable##*=}
        if ! [[ ${variableName} = ${1} ]];
        then
            unset ${variableName}
            eval echo "${variableName}=${variableValue} >> ./.env-temp"
        fi
    done < "./.env"
    eval echo "${1}=${2} >> ./.env-temp"
    rm -rf ./.env
    mv ./.env-temp ./.env
    source ./.env
}

function taskNotAvailable {
    printError "Task not available"

    ask "Would you like to set again the task? [Y/n] "
    read ANSWER
    ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`

    if [ ${ANSWER} = "y" ]; then
        $1
    fi
}

function checkForVpn {
    ping -q -c3 ${FTP_IP} > /dev/null

    if [ $? -eq 0 ]
    then
        echo $?
    fi
}

function release {
    if [[ -z ${FTP_IP} ]];
    then
        printError "FTP Ip is not set"
        setEnvironment false
    fi

    currentBranch=$(getCurrentBranch)
    if [[ ${currentBranch} != "develop" ]]; then
        printWarning "Cannot compile on '${currentBranch}'."

        CHANGES_TO_BE_COMMITED=$(git status --porcelain)
        if [[ -z ${CHANGES_TO_BE_COMMITED} ]];
        then
            printNotificationMessage "Nothing to commit, working tree clean"
        else
            printNotificationMessage "Please commit your changes!"
            commit
        fi

        ask "Is this branch '${currentBranch}' merged to 'develop? [Y/n]"
        read ANSWER_MERGED_BRANCH
        ANSWER_MERGED_BRANCH=`echo "$ANSWER_MERGED_BRANCH" | tr '[:upper:]' '[:lower:]'`

        if [[ ${ANSWER_MERGED_BRANCH} = "n" ]];
        then
            printNotificationMessage "Create a new PR and assign to a developer. Once is approved and merged you'll be release."
            return
        else
            git checkout develop
            git pull
        fi
    fi

    printNotificationMessage "Checking for VPN connection ..."
    local VPN_STATUS=$(checkForVpn)

    if [[ ${VPN_STATUS} = "0" ]];
    then
        printSuccessMessage "VPN connected."

        git pull

        if [[ -z ${FTP_USERNAME} ]]; then
            setFtpUser
        else
            printWarning "'${FTP_USERNAME}' is set to your environment. Would you like to change it? [Y/n]"
            read FTP_ANSWER
            FTP_ANSWER=`echo "$FTP_ANSWER" | tr '[:upper:]' '[:lower:]'`

            if [ $FTP_ANSWER = "y" ]; then
                setFtpUser
            fi
        fi

        checkForEnv
        showAppEnvs

        ask "Would you like to compile with this values? [Y/n] "
        read ANSWER
        ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`

        if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "y" ]; then
            printError "Value not recognized '$ANSWER'. Available values [Y/n] "
            return
        fi

        if [ "$ANSWER" = "n" ]; then
            askToSetEnv
            return
        fi

        if [ "$ANSWER" = "y" ]; then
            updateVersion
            compileAppEnvs
            updateChangelog
            #generateZip
            npm run build
            copyBuilt
            uploadToGit "version ${APP_VERSION}"
            updateToFTP
        fi
    else
        printError "VPN disconnected. Try it later once yor VPN is connected"
        return 0
    fi
}

function compileAppEnvs {
    touch ./.env-temp

    if [[ -a "./.env" ]];
    then
        while read LINE; do
            if [[ ${LINE%%=*} = "FTP_USERNAME" ]];
            then
                eval echo "${LINE%%=*}=${LINE##*=} >> ./.env-temp"
            fi
        done < "./.env"
    fi

    eval echo "APP_DEBUG=${APP_DEBUG} >> .env-temp"
    eval echo "APP_ENV=${APP_ENV} >> .env-temp"
    eval echo "APP_SERVER_ADDRESS=${APP_SERVER_ADDRESS} >> .env-temp"
    eval echo "APP_VERSION=${APP_VERSION} >> .env-temp"

    rm -rf ./.env
    mv ./.env-temp ./.env
    source ./.env

    compileEnvsToJavascript
}

function compileEnvsToJavascript {

    if [ -z ${APP_DEBUG} ]; then
        printError "Cannot compile js file before setting up the environment"
        setEnvironment false
        return
    fi

    printNotificationMessage "Set version '${APP_VERSION}' to current environment"

    eval echo '> env.js'
    eval echo '// Auto-generated file created by `eval git config user.name` `date +%d/%m/%Y` at `date +%T`hs >> env.js'

    eval echo 'export const APP_VERSION \= "\""${APP_VERSION}""\"\; >> env.js'

    _APP_ENV=`echo "$APP_ENV" | tr '[:lower:]' '[:upper:]'`
    _OIDC_CLIENT_ID=`echo CLIENT_ID_${_APP_ENV}`
    eval echo 'export const SERVER_ENVIRONMENT_MODE \= "\""${APP_ENV}""\"\; >> env.js'
    eval echo 'export const OIDC_CLIENT_ID \= "\""${!_OIDC_CLIENT_ID}""\"\; >> env.js'

    eval echo 'export const ENVIRONMENTS \= { >> env.js'
    eval echo '""\"staging""\"\:\{""\"key""\": ""\"staging""\"\, ""\"url""\": ""\"${SERVER_ADDRESS_STAGING}""\"\}\, >> env.js'
    eval echo '""\"production""\"\:\{""\"key""\": ""\"production""\"\, ""\"url""\": ""\"${SERVER_ADDRESS_PRODUCTION}""\"\}\, >> env.js'
    eval echo '\}\; >> env.js'

    eval mv ./env.js ./src/
}

function setEnvironment {
    declare -a arrAllowEnvs
    setDebugMode

    local debugMode=${1}
    local allowed=false

    if [ ${debugMode} = true ]; then
        local strAllowEnvs="develop | staging"
        arrAllowEnvs=(develop staging)
    else
        local strAllowEnvs="staging | production"
        arrAllowEnvs=(staging production)
    fi

    ask "Set up environment values. Available values [ $strAllowEnvs ] "
    read ANSWER_ENV

    if [[ -z ${ANSWER_ENV} ]]; then
        printWarning "Cannot set empty value"
        return
    fi

    for i in ${arrAllowEnvs[*]}; do
        if [[ ${i} = ${ANSWER_ENV} ]];
        then
            allowed=true
        fi
    done

    getCurrentVersion
    addVariableToEnv "APP_ENV" ${ANSWER_ENV}

    if ! $allowed = false; then
        printError "Value not recognized. Available values [ $strAllowEnvs ] "
        setEnvironment ${debugMode}
        return
    else
        setAppEnvs
        compileAppEnvs
    fi
}

function copyBuilt {
    CURRENT_VERSION="${APP_VERSION}"
    rm -rf ./builds/temp
    rm -rf ./builds/${CURRENT_VERSION}
    mkdir ./builds/temp
    cp -rf ./build/* ./builds/temp
    mv ./builds/temp ./builds/v${CURRENT_VERSION}
    printSuccessMessage "${APP_NAME} has been successfully built ${CURRENT_VERSION} $(smileIcon)"
}

function generateZip {
    rm -rf ./builds/temp
    cp -rf ./build ./builds
    mv ./builds/build ./builds/temp
    zip -r ./builds/a.zip builds/temp/*
}

function askToSetEnv() {
    ask "Would you like to set again the environment? [Y/n] "
    read ANSWER
    ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`

    if [ "${ANSWER}" = "y" ]; then
        setEnvironment false
        release
    fi
}

function install {
    npm install
}

function runApp {
    npm run all
}

function fixNpm {
    npm cache clean --force
    rm -rf node_modules/
    rm package-lock.json
}

function fixProject {
    fixNpm
    install
}

function showHelp {
    echo ""
    cat cli/docs/app-cli.md
    echo ""
}

function getAutogeneratedMessage {
    echo "Auto-generated file created by `git config user.name` $(date +%d/%m/%Y) at $(date +%T)hs"
}

function getAutoUpdatedMessage {
    echo "Auto-updated file by `git config user.name` $(date +%d/%m/%Y) at $(date +%T)hs"
}

function removeIcon {
    echo ${BACKGROUND_COLOR_RED_1}${COLOR_WHITE}" X "${RESET_COLOR}
}

function errorIcon {
    echo ${BACKGROUND_COLOR_RED_1}${COLOR_WHITE}" X "${RESET_COLOR}
}

function warningIcon {
    echo ${BACKGROUND_COLOR_ORANGE_1}${COLOR_WHITE}" ! "${RESET_COLOR}
}

function smileIcon {
    echo ${BACKGROUND_COLOR_YELLOW_1}${COLOR_BLACK_1}" :) "${RESET_COLOR}
}

function successIcon {
    echo ${BACKGROUND_COLOR_GREEN_1}${COLOR_WHITE}" √ "${RESET_COLOR}
}

function notificationIcon {
    echo ${BACKGROUND_COLOR_CYAN_1}${COLOR_WHITE}" > "${RESET_COLOR}
}

function helpIcon {
    echo ${BACKGROUND_COLOR_BLUE_1}${COLOR_WHITE}" ? "${RESET_COLOR}
}

function ask {
    echo -n "${QUESTION_COLOR}${1}${RESET_COLOR}"
}

function askAndGo {
    echo -n "${QUESTION_COLOR}${1}${RESET_COLOR}"
    read ANSWER
    ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`

    while [ "$ANSWER" != "n" ] && [ "$ANSWER" != "y" ];
    do
        printError "Value not recognized"
        ask "${1}"
        read ANSWER
        ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`
    done

    if [ "$ANSWER" = "y" ]; then
        ${2}
        return
    fi

    if [ "$ANSWER" = "n" ]; then
        ${3}
        return
    fi
}

function printError {
    echo "$(errorIcon) ${ERROR_COLOR}${1}${RESET_COLOR}"
    sleep .5
}

function printWarning {
    echo "$(warningIcon) ${WARNING_COLOR}${1}${RESET_COLOR}"
    sleep .5
}

function printSuccessMessage {
    echo "$(successIcon) ${SUCCESFUL_COLOR}${1}${RESET_COLOR}"
    sleep .5
}

function printNotificationMessage {
    echo "$(notificationIcon) ${NOTIFICATION_COLOR}${1}${RESET_COLOR}"
    sleep .25
}

function showColors {
    for i in {1..300}; do
        echo $(tput setaf "${i}")"COLOR "${i}
    done
}

function parseToLowerCase {
    echo "${1}" | tr '[:upper:]' '[:lower:]'
}

function parseToUpperCase {
    echo "${1}" | tr '[:lower:]' '[:upper:]'
}

function showMainMenu {
    eval "clear"
    renderMenu
    ask ${COLOR_PINK_1}"Select task: "${RESET_COLOR}
    read TASK

    runTask ${TASK}

    while [[ ${TASK} != "0" ]] || [[ ${TASK} = "" ]];
    do
        renderMenu
        ask ${COLOR_PINK_1}"Select task: "${RESET_COLOR}
        read TASK
        runTask ${TASK}
    done
}

function renderMenu {
    echo ""
    echo ${RESET_COLOR}${BACKGROUND_COLOR_PINK_1}"     ${APP_NAME} - Main menu      "${RESET_COLOR}
    echo "${COLOR_GREY_2}___________________________________"
    echo "Current Version: "${VALUE_COLOR}${APP_VERSION}${COLOR_GREY_2}
    echo "Current branch: "${VALUE_COLOR}$(getCurrentBranch)

    [[ -z ${APP_ENV} ]] && _appEnv="`errorIcon` not set" || _appEnv="${APP_ENV}"

    echo ${COLOR_GREY_2}"Environment mode: ${VALUE_COLOR}${_appEnv}${COLOR_GREY_2}${RESET_COLOR}"
    echo "${COLOR_GREY_2}___________________________________"
    echo ""

    echo ${BACKGROUND_COLOR_ORANGE_1}${COLOR_BLACK_1}"[1]  GIT                           "${RESET_COLOR}
    echo ${BACKGROUND_COLOR_ORANGE_2}${COLOR_BLACK_1}"[2]  React                         "${RESET_COLOR}
    echo ${BACKGROUND_COLOR_GREEN_2}${COLOR_BLACK_1}"[3]  FTP                           "${RESET_COLOR}
    echo ${APPLICATION_BACKGROUND_COLOR}${COLOR_BLACK_1}"     Application                   "${RESET_COLOR}
    echo ${APPLICATION_COLOR}"[4]  Install app"
    echo "[5]  Run application"
    echo "[6]  Fix project"
    echo "[7]  Set application env variables"
    echo "[8]  Set application sass variables"
    echo "[9]  Show application env variables"
    echo ${COLOR_YELLOW_1}"[10] Release"${RESET_COLOR}
    echo ${COLOR_RED_1}"[11] Remove app env vars "${RESET_COLOR}
    echo "${COLOR_GREY_2}____________________________________"
    echo "${BACKGROUND_COLOR_RED_1}${COLOR_WHITE}[0]  Exit "${RESET_COLOR}" or $(helpIcon) for help"
    echo "${COLOR_GREY_2}____________________________________"${RESET_COLOR}
}

function runTask {
    case "$TASK" in
    '1')
        initGitProgram showMainMenu
    ;;
    '2')
        initReactProgram showMainMenu
    ;;
    '3')
        initFtpProgram showMainMenu
    ;;
    '4')
        install
    ;;
    '5')
        runApp
    ;;
    '6')
        fixProject
    ;;
    '7')
        setEnvironment false
    ;;
    '8')
        setupVariablesFile
    ;;
    '9')
        eval "clear"
        showAppEnvs
    ;;
    '10')
        release
    ;;
    '11')
        removeEnvs
    ;;
    '20')
        setupConfigFile
    ;;
    '21')
        setup
    ;;
    '?')
        showHelp
    ;;
    '0')
        echo ""
        echo ${COLOR_RED_1}"Good bye ..."${RESET_COLOR}
        echo ""
    ;;
    *)
        taskNotAvailable init
    ;;
    esac
}

function init {
    clear
    printNotificationMessage "Loading program ..."
    checkForEnv
    setupVariablesFile
    showMainMenu
}

if [ ! -f "./.app-cli.config" ]; then
    setupConfigFile
else
    source .app-cli.config
    source ./cli/src/modules/ftp/ftp-cli.sh
    source ./cli/src/modules/git/git-cli.sh
    source ./cli/src/modules/react/react-cli.sh

    init ${1}
fi