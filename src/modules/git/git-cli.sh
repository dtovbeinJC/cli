#!/bin/bash

#==============================================================================
#author         :Dan Tovbein (https://github.com/dtovbeinJC)
#title          :CFG2 Automation Program
#notes          :See app-cli.md for documentation
#version        :1.0.0
#bash_version   :GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin16)
#==============================================================================


function removeTagVersion {
    ask "Select version: "
    read VERSION

    git push --delete origin ${VERSION}
    git tag -d ${VERSION}

    ask "Remove another tag version? [Y/n] "
    read ANSWER
    ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`

    while [ "$ANSWER" != "n" ] && [ "$ANSWER" != "y" ];
    do
        printError "Value not recognized"
        ask "Remove another tag version? [Y/n] "
        read ANSWER
        ANSWER=`echo "$ANSWER" | tr '[:upper:]' '[:lower:]'`
    done

    if [ "$ANSWER" = "y" ]; then
        removeTagVersion
        return
    fi
}

function checkoutToBranch {
    ask "Write branch's name: "
    read BRANCH_NAME

    while [[ -z ${BRANCH_NAME} ]]; do
        printWarning "Cannot write empty name"
        ask "Please write branch's name: "
        read BRANCH_NAME
    done

    local exist=false
    touch .branch && eval `echo git branch` > .branch
    while read LINE; do
        if [[ "${BRANCH_NAME}" == "${LINE}" ]] || [[ "${BRANCH_NAME}" == $(getCurrentBranch) ]];
        then
            echo "${BRANCH_NAME} ${LINE}"
            exist=true
        fi
    done < .branch
    rm -rf .branch

    if [[ ${exist} = false ]]; then
        printError "Unavailable branch ${BRANCH_NAME}"
    else
        printNotificationMessage "Checking out to ${BRANCH_NAME}"
    fi

    #git stash
    git checkout develop
    git fetch
    git pull
    git checkout ${BRANCH_NAME}
    git rebase develop
    #git stash pop
}

function deleteBranch {
    ask "Write the branch name: "
    read BRANCH_NAME

    while [ "$BRANCH_NAME" = "" ];
    do
        printError "Value not recognized"
        ask "Write the branch name: "
        read BRANCH_NAME
    done

    git push -d origin ${BRANCH_NAME}
    git branch -D ${BRANCH_NAME}
}

function getCurrentVersion {
    local version=$(echo `git fetch && git describe --tags $(eval git rev-list --tags --max-count=1)`)

    if [[ -z ${version} ]]
    then
        version="0.0.0"
    fi

    addVariableToEnv "APP_VERSION" ${version}
}

function updateVersion {

    if [[ -z ${1} ]];
    then
        printNotificationMessage "Remote version ${COLOR_RED_1}'${APP_VERSION}'${RESET_COLOR}"

        ask "Update version manually? [Y/n] "
        read UPDATE_MANUALLY_ANSWER
        UPDATE_MANUALLY_ANSWER=`echo "$UPDATE_MANUALLY_ANSWER" | tr '[:upper:]' '[:lower:]'`

        local currentVersion=$(echo ${APP_VERSION}| cut -d'v' -f 2)
        local newVersion

        local x=${currentVersion%.*}
        x=${x%.*}
        local y=${currentVersion%.*}
        y=${y#*.}
        local z=${currentVersion#*.}
        z=${z#*.}

        echo ""
        echo "------------------------------------------------------------------------------------"
        printWarning "X: Make incompatible API changes. ${BACKGROUND_COLOR_PINK_1}${COLOR_WHITE} ${x} > $(( ${x} + 1 )) "
        printWarning "Y: Add functionality in a backwards-compatible manner. ${BACKGROUND_COLOR_PINK_1}${COLOR_WHITE} ${y} > $(( ${y} + 1 )) "
        printWarning "Z: Make backwards-compatible bug fixes. ${BACKGROUND_COLOR_PINK_1}${COLOR_WHITE} ${z} > $(( ${z} + 1 )) "
        echo "------------------------------------------------------------------------------------"
    else
        UPDATE_MANUALLY_ANSWER=${1}
    fi

    if [ ${UPDATE_MANUALLY_ANSWER} = "n" ]; then
        ask "Update to [ X,Y,Z ]:${RESET_COLOR}${COLOR_CYAN_1} "
        read typeOfVersionUpdate
        typeOfVersionUpdate=`echo "${typeOfVersionUpdate}" | tr '[:upper:]' '[:lower:]'`

        if [[ -z ${typeOfVersionUpdate} ]]; then
            printError "Invalid type of version"
            updateVersion
            return
        fi

        if [ ${typeOfVersionUpdate} != "x" ] && [ ${typeOfVersionUpdate} != "y" ] && [ ${typeOfVersionUpdate} != "z" ]; then
            printError "Value not recognized for '${typeOfVersionUpdate}'. Available values [ X,Y,Z ] "
            updateVersion
            return
        fi

        if [ "${currentVersion}" = "" ]
        then
            echo "No version available"
        fi

        if [[ ${typeOfVersionUpdate} = "x" ]]; then
            x=$(($x+1))
            y="0"
            z="0"
        fi

        if [[ ${typeOfVersionUpdate} = "y" ]]; then
            y=$(($y+1))
            z="0"
        fi

        if [[ ${typeOfVersionUpdate} = "z" ]]; then
            z=$(($z+1))
        fi

        newVersion="${x}.${y}.${z}"
    else
        ask "X [Enter to '${x}']: "
        read X_PARAM
        #X_PARAM=$(validateVersionParam ${x} ${X_PARAM})

        ask "Y [Enter to '${y}']: "
        read Y_PARAM
        #Y_PARAM=$(validateVersionParam ${y} ${Y_PARAM})

        ask "Z [Enter to '${z}']: "
        read Z_PARAM
        #Z_PARAM=$(validateVersionParam ${z} ${Z_PARAM})

        newVersion="${X_PARAM}.${Y_PARAM}.${Z_PARAM}"

        echo ${newVersion}
    fi

    if [[ ${newVersion} =~ ${currentVersion} ]];
    then
        printError "Invalid version '${newVersion}'. It should be greater."
        sleep 1
        updateVersion ${UPDATE_MANUALLY_ANSWER}
    else
        printNotificationMessage "Set new version to '${newVersion}'"
        addVariableToEnv "APP_VERSION" ${newVersion}
    fi
}

#function validateVersionParam {
    #local currentVersion=$1
    #local newVersion=$2

    #echo "currentVersion: ${currentVersion} newVersion: ${newVersion}"

#    echo ${X_PARAM}
#
    #if [[ -z ${X_PARAM} ]];
    #then
    #s    local versionValue=${currentVersion}
    #else
    #    if [[ ${newVersion} -gt ${currentVersion} ]];
    #    then
    #        local versionValue=${newVersion}
    #    else
    #        local versionValue=${currentVersion}
    #    fi
    #fi
#
#    echo ${versionValue}

    #eval "echo ${versionValue}"
#}

function getLastestCommit {
    lastCommit=$(`echo git rev-parse --short HEAD`)
    echo ${lastCommit}
}

function getLastestTag {
    rm -rf .tags
    touch .tags
    for TAG in $( git tag )
    do
        eval echo '$TAG >> .tags'
    done
}

function getCommitsBetweenTags {
    commits=""
    git log $(getLastestTag)..${APP_VERSION} --pretty=oneline | while read commit; do
        commits+=${commit}
    done

    if [ "${commits}" = "" ]; then
        commits+="There is no commits between $(getLastestTag) and ${APP_VERSION}"
    fi

    echo ${commits}
}

function uploadToGit {
    local currentBranch=$(getCurrentBranch)

    eval "git add ."
    eval "git commit -m ""\"[${currentBranch}]:${1}""\""
    eval "git tag -a ${APP_VERSION} -m ""\"[${currentBranch}]:${1}""\""
    eval "git push origin ${currentBranch}"
    eval "git push --tags"
}

function createVersionFile {
    source ./.env
    FILE_NAME="v${APP_VERSION}.md"
    FILE_PATH='./versions/'
    FILE=${FILE_PATH}${FILE_NAME}
    eval 'touch ${FILE_PATH}${FILE_NAME}'
    eval echo '\# ${APP_VERSION} >> ${FILE}'
    eval echo 'Generated version `date +%m/%d/%Y` at `date +%T` by \*\*`eval git config user.name`\*\* >> ${FILE}'
    eval echo '\#\#\# Configuration: >> ${FILE}'
    eval echo 'Server: ${APP_SERVER_ADDRESS} >> ${FILE}'
    eval echo ' >> ${FILE}'
    eval echo 'Environment: ${APP_ENV} >> ${FILE}'
    eval echo ' >> ${FILE}'
    eval echo 'debug: ${APP_DEBUG} >> ${FILE}'
    eval echo ' >> ${FILE}'
    eval echo '--- >> ${FILE}'

    printNotificationMessage "ENTER to insert / Double ENTER to quit"

    eval echo '\#\#\# Improvements: >> ${FILE}'

    ask "Insert an improvement: "
    read IMPROVEMENT_ITEM

    IMPROVEMENT_ITEM_LOWER=`eval echo $(parseToLowerCase "${IMPROVEMENT_ITEM}")`
    eval echo '\* ${IMPROVEMENT_ITEM_LOWER} >> ${FILE}'

    while [[ -n ${IMPROVEMENT_ITEM} ]];
    do
        ask "Insert an improvement: "
        read IMPROVEMENT_ITEM

        if [[ -n ${IMPROVEMENT_ITEM} ]];
        then
            IMPROVEMENT_ITEM_LOWER=`eval echo $(parseToLowerCase "${IMPROVEMENT_ITEM}")`
            eval echo '\* ${IMPROVEMENT_ITEM_LOWER} >> ${FILE}'
        fi
    done

    eval echo '--- >> ${FILE}'
    eval echo '\#\#\# Included commits >> ${FILE}'
    eval echo '$(git --no-pager log >> ${FILE})'
    eval echo '--- >> ${FILE}'
}

function updateChangelog {
    createVersionFile

    FILE_NAME="changelog.md"
    eval echo '\* \[v${APP_VERSION}\]\(\.\/versions\/v${APP_VERSION}\.md\) >> ${FILE_NAME}'
}

function getCurrentBranch {
    eval "echo `git rev-parse --abbrev-ref HEAD`"
}

function commit {
    local currentBranch=$(getCurrentBranch)
    if [ "${currentBranch}" = "master" ] || [ "${currentBranch}" = "develop" ];
    then
        printError "Is not allowed to commit any change from 'master' or 'develop'."
        printNotificationMessage "Please create a new branch"
        sleep 2
        return
    fi

    ask "Set a message: "
    read MESSAGE

    while [[ -z ${MESSAGE} ]]
    do
       printWarning "Cannot set empty message"
       ask "Set a message again: "
       read MESSAGE
    done

    local message=`echo "${MESSAGE// /_}" | tr '[:upper:]' '[:lower:]'`

    updateVersion
    compileAppEnvs
    updateChangelog
    uploadToGit ${message}

    printSuccessMessage "All changes has been successfully updated"
}

function createBranch {

    if [ "${1}" = true ];
    then
        eval echo '$(git stash)'
    fi

    ask "Set the ticket ID: "
    read TICKET_ID

    re='^[0-9]+$'
    while [ -z ${TICKET_ID} ] || ! [[ ${TICKET_ID} =~ $re ]]
    do
       printError "Set a valid ticket ID"
       ask "Set the ticket ID: "
       read TICKET_ID
    done

    local BRANCH_NAME="${APP_NAME_PREFFIX}-${TICKET_ID}"
    git checkout -b ${APP_NAME_PREFFIX}-${TICKET_ID}

    if [ "${1}" = true ];
    then
        git stash pop
    fi

    printSuccessMessage "${BRANCH_NAME} has been created"
}

function initGitProgram {
    echo ${BACKGROUND_COLOR_YELLOW_1}${COLOR_BLACK_1}"  GIT                               "${RESET_COLOR}
    echo ${COLOR_ORANGE_1}"[1]  Create a new branch"
    echo "[2]  Commit changes"
    echo "${COLOR_ORANGE_1}[3]  Checkout to branch"
    echo ${COLOR_RED_1}"[4]  Reset edited files"${RESET_COLOR}
    echo ${COLOR_RED_1}"[5]  Remove branch"${RESET_COLOR}
    echo ${COLOR_RED_1}"[6]  Remove tag version"${RESET_COLOR}
    echo ${RESET_COLOR}"[0]  Back to main menu"

    ask ${COLOR_PINK_1}"Select task: "${RESET_COLOR}
    read TASK

    case "$TASK" in
    '1')
        createBranch false
    ;;
    '2')
        commit
    ;;
    '3')
        checkoutToBranch
    ;;
    '4')
        git checkout .
    ;;
    '5')
        deleteBranch
    ;;
    '6')
        removeTagVersion
    ;;
    '0')
        ${1}
    ;;
    *)
        taskNotAvailable initGitProgram
    ;;
    esac
}