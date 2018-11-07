#!/bin/bash

#==============================================================================
#author         :Dan Tovbein (https://github.com/dantovbein)
#title          :CLI Automation Program
#notes          :See app-cli.md for documentation
#version        :1.0.0
#bash_version   :GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin16)
#==============================================================================


declare COMPONENTS_PATH="${SOURCE_PATH}components/"
declare CONTAINERS_PATH="${SOURCE_PATH}containers/"
declare ACTIONS_PATH="${SOURCE_PATH}actions/"
declare REDUCERS_PATH="${SOURCE_PATH}reducers/"
declare CONSTANTS_PATH="${SOURCE_PATH}constants/"
declare UTILS_PATH="${SOURCE_PATH}utils/"
declare SASS_PATH="${SOURCE_PATH}sass/"
declare MEDIA_PATH="${SOURCE_PATH}media"

function setupBaseApp {
    
    if ! [ -d "${SASS_PATH}" ]; then
        mkdir "${SASS_PATH}"
    else
        printWarning "SASS directory exists"    
    fi
    
    if ! [ -d "${COMPONENTS_PATH}" ]; then
        mkdir "${COMPONENTS_PATH}"
    else
        printWarning "Components directory exists"    
    fi
    
    if ! [ -d "${CONTAINERS_PATH}" ]; then
        mkdir "${CONTAINERS_PATH}"
    else
        printWarning "Containers directory exists"    
    fi
        
    if ! [ -d "${ACTIONS_PATH}" ]; then
        mkdir "${ACTIONS_PATH}"
    else
        printWarning "Actions directory exists"    
    fi

    if ! [ -d "${REDUCERS_PATH}" ]; then
        mkdir "${REDUCERS_PATH}"
        touch "${REDUCERS_PATH}index.js"
    else
        printWarning "Reducers directory exists"    
    fi

    if ! [ -d "${CONSTANTS_PATH}" ]; then
        mkdir "${CONSTANTS_PATH}"
        touch "${CONSTANTS_PATH}index.js"
    else
        printWarning "Constants directory exists"    
    fi

    if ! [ -d "${UTILS_PATH}" ]; then
        mkdir "${UTILS_PATH}"
        touch "${UTILS_PATH}index.js"
    else
        printWarning "Utils directory exists"    
    fi
    
    if ! [ -d "${MEDIA_PATH}" ]; then
        mkdir "${MEDIA_PATH}"
        mkdir "${MEDIA_PATH}/fonts"
        mkdir "${MEDIA_PATH}/images"
    else
        printWarning "Media directory exists"    
    fi
    
    #mv ./cli/src/modules/react/reducers__index.js ./src/reducers/index.js
}

function createComponent {
  local -a arrAllowExtensions
  local arrExtensionsAllowed=(1 2)
  local listExtensionsAllowed="${RESET_COLOR}[1] Javascript [2] Typescript"
  local strExtensionsAllowed=${RESET_COLOR}"Javascript, Typescript"
  local extensionsAllowed=false

  local -a arrAllowEnvs
  local arrAllowed=(1 2 3)

  local listComponentAllowed="${RESET_COLOR}[1] View [2] Snippet [3] Widget"
  local strComponentAllowed=${RESET_COLOR}"View, Snippet, Widget"
  local componentAllowed=false

  local listReactComponentAllowed="${RESET_COLOR}[1] Functional [2] Class [3] Container"
  local strReactComponentAllowed=${RESET_COLOR}"Functional, Class, Container"
  local reactComponentAllowed=false

  local COMPONENT_FULL_PATH=""
  local COMPONENT_FORMAT=""
  local COMPONENT_EXTENSION=""
  local COMPONENT_TYPE=""
  local COMPONENT_DIRECTORY=""
  local EXAMPLE_FILE_NAME=""
  local FILE_EXTENSION=""
  local EXAMPLES_COMPONENT_PATH=""  

  echo ${listExtensionsAllowed}
  ask "Set extension of Component to: "
  read COMPONENT_EXTENSION  

    while [[ -z ${COMPONENT_EXTENSION} ]];
    do
        printWarning "Cannot set an empty extension"
        echo ${listExtensionsAllowed}
        ask "Set extension of Component: "
        read COMPONENT_EXTENSION
    done;

    if [[ ${COMPONENT_EXTENSION} = "1" ]];
    then
        FILE_EXTENSION="js"
    fi

    if [[ ${COMPONENT_EXTENSION} = "2" ]];
    then
        FILE_EXTENSION="ts"
    fi
    
    for i in ${arrExtensionsAllowed[*]}; do
    if [[ ${i} = ${COMPONENT_EXTENSION} ]];
    then
        extensionsAllowed=true
    fi
  done

  if ! ${extensionsAllowed} = false; then
    printError "Incorrect value. Available values ${RESET_COLOR}[ $strExtensionsAllowed ]: "
    createComponent
    return
  fi

  echo ${listComponentAllowed}
  ask "Set type of Component: "
  read COMPONENT_FORMAT

  while [[ -z ${COMPONENT_FORMAT} ]];
  do
    printWarning "Cannot set an empty type"
    echo ${listComponentAllowed}
    ask "Set type of Component: "
    read COMPONENT_FORMAT
  done;

  for i in ${arrAllowed[*]}; do
    if [[ ${i} = ${COMPONENT_FORMAT} ]];
    then
      componentAllowed=true
    fi
  done

  if ! ${componentAllowed} = false; then
    printError "Incorrect value. Available values ${RESET_COLOR}[ $strComponentAllowed ]: "
    createComponent
    return
  fi

  suggested=""
  if [[ ${COMPONENT_FORMAT} = "1" ]];
  then
    suggested="Container, Class"
  else
    suggested="Functional, Class"
  fi

  echo ${listReactComponentAllowed}
  ask "Set type of React Component ${COLOR_GREEN_1}(${suggested})${RESET_COLOR}: "
  read REACT_COMPONENT_TYPE

  while [[ -z ${REACT_COMPONENT_TYPE} ]];
  do
    printWarning "Cannot set an empty type"
    echo ${listReactComponentAllowed}
    ask "Set type of React Component ${COLOR_GREEN_1}(${suggested})${RESET_COLOR}: "
    read REACT_COMPONENT_TYPE
  done;

  [[ "${REACT_COMPONENT_TYPE}" = "3" ]] && local DIR="containers" || local DIR="components"

  for i in ${arrAllowed[*]}; do
    if [[ ${i} = ${REACT_COMPONENT_TYPE} ]];
    then
        reactComponentAllowed=true
    fi
  done

  if ! ${reactComponentAllowed} = false; then
      printError "Incorrect value. Available values ${RESET_COLOR}[ $strReactComponentAllowed ]: "
      createComponent
      return
  fi

  ask "Write a name of your component (CamelCase): "
  read COMPONENT_NAME

  while [[ -z ${COMPONENT_NAME} ]]; do
      printWarning "Cannot set an empty name"
      ask "Please write a new component name (CamelCase): "
      read COMPONENT_NAME
  done;

 COMPONENT_NAME=$(echo "${COMPONENT_NAME:0:1}" | tr '[:lower:]' '[:upper:]')${COMPONENT_NAME:1}

 local _ORIGIN_EXAMPLES_PATH="${ORIGIN_EXAMPLES_PATH/:EXTENSION:/${FILE_EXTENSION}}"

 local _ORIGIN_COMPONENT_PATH="${ORIGIN_COMPONENT_PATH/:EXTENSION:/${FILE_EXTENSION}}"
 _ORIGIN_COMPONENT_PATH="${_ORIGIN_COMPONENT_PATH/:COMPONENT_TYPE:/${DIR}}"

 local _OUTPUT_COMPONENT_PATH="${OUTPUT_COMPONENT_PATH/:COMPONENT_TYPE:/${DIR}}${COMPONENT_NAME}"
#

  case "$REACT_COMPONENT_TYPE" in
  '1')
      COMPONENT_TYPE="Functional"
  ;;
  '2')
      COMPONENT_TYPE="Class"
  ;;
  '3')
      COMPONENT_TYPE="Smart"
  ;;
  esac

  copyFiles "${COMPONENT_NAME}" "${COMPONENT_TYPE}" "${FILE_EXTENSION}" "${_ORIGIN_COMPONENT_PATH}" "${_OUTPUT_COMPONENT_PATH}" "${_ORIGIN_EXAMPLES_PATH}"
  askAndGo "Create another component? [Y/n] " createComponent
}

function createReducer {
    ask "Write a name of your reducer (CamelCase): "
    read REDUCER_NAME

    while [ "${REDUCER_NAME}" = "" ];
    do
        printWarning "Cannot set an empty name"
        ask "Please write a new reducer name (CamelCase): "
        read REDUCER_NAME
    done;

    REDUCER_NAME=$(echo "${REDUCER_NAME:0:1}" | tr '[:lower:]' '[:upper:]')${REDUCER_NAME:1}

    COMPONENT_DIRECTORY="containers/"
    COMPONENT_TYPE="Reducer"
    COMPONENT_FULL_PATH="${REDUCERS_PATH}${REDUCER_NAME}"

    echo "${COMPONENT_FULL_PATH} ${COMPONENT_TYPE}"

    copyFiles "${REDUCER_NAME}" "${COMPONENT_TYPE}" "js" "${COMPONENT_DIRECTORY}" "${COMPONENT_FULL_PATH}"
    askAndGo "Create another reducer? [Y/n] " createReducer showAllReducers
}


#######################################
# Copy files from origin examples path
# Globals:
#   NAME 1
#   TYPE 2
#   FILE_EXTENSION 3
#   OUTPUT_PATH 4
#   ORIGIN_PATH 5
#   ORIGIN_EXAMPLES_PATH 6
# Arguments:
#   None
# Returns:
#   None
#######################################
function copyFiles {
    local _NAME="${1}"
    local _TYPE="${2}"
    local _FILE_EXTENSION="${3}"
    local _ORIGIN_PATH="${4}"
    local _OUTPUT_PATH="${5}"
    local _ORIGIN_EXAMPLES_PATH="${6}"

    CLASS_NAME=$(sed -e "s/\([A-Z]\)/-\1/g" -e "s/^-//" <<< "${_NAME}")
    CLASS_NAME=$(echo ${CLASS_NAME} | tr '[:upper:]' '[:lower:]')
    SAMPLE_ACTION_FUNCTION="sample${_NAME}Action"

    SAMPLE_ACTION_CONSTANT_LOWER_CASE="${_NAME}"
    SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE=$(echo "${_NAME:0:1}" | tr '[:upper:]' '[:lower:]')${_NAME:1}

    SAMPLE_ACTION_CONSTANT=$(sed -e "s/\([A-Z]\)/_\1/g" -e "s/^_//"  <<< "${_NAME}")
    SAMPLE_ACTION_CONSTANT=$(echo ${SAMPLE_ACTION_CONSTANT} | tr '[:lower:]' '[:upper:]')

    CONSTANTS_IMPORT_PATH="..\/..\/constants\/"

    MAIN_TAG="div"

    if [[ ${_FILE_EXTENSION} = "1" ]]; then
        MAIN_TAG="section"
    fi

    mkdir ${_OUTPUT_PATH}

    if [ "${_TYPE}" = "Reducer" ];
    then
        touch ${_OUTPUT_PATH}/reducer.js
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> ${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION} && echo "" >> ${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}`
        cat ${_ORIGIN_EXAMPLES_PATH}${_ORIGIN_PATH}reducer.${_FILE_EXTENSION} >> ${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}
        sed -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" -e "s/CONSTANTS_PATH/${CONSTANTS_IMPORT_PATH}/g" ${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION} > ${_OUTPUT_PATH}/reducer-temp.${_FILE_EXTENSION}
        mv ${_OUTPUT_PATH}/reducer-temp.${_FILE_EXTENSION} ${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}

        touch ${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> ${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION} && echo "" >> ${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}`
        cat ${_ORIGIN_EXAMPLES_PATH}${_ORIGIN_PATH}reducer_test.${_FILE_EXTENSION} >> ${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}
        sed -e "s/ComponentName/${_NAME}/g" -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" -e "s/CONSTANTS_PATH/${CONSTANTS_IMPORT_PATH}/g" ${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION} > ${_OUTPUT_PATH}/reducer.test-temp.${_FILE_EXTENSION}
        mv ${_OUTPUT_PATH}/reducer.test-temp.${_FILE_EXTENSION} ${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}

        addReducerToFile "${_NAME}" "${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}" "reducer"

        eval `echo "export const ${SAMPLE_ACTION_CONSTANT} = \""${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}"\";" >> ./src/constants/index`
    else
        touch "${_OUTPUT_PATH}/index.${_FILE_EXTENSION}x"
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> ${_OUTPUT_PATH}/index.${_FILE_EXTENSION}x && echo "" >> ${_OUTPUT_PATH}/index.${_FILE_EXTENSION}x`
        cat "${_ORIGIN_PATH}${_TYPE}Component.${_FILE_EXTENSION}x" >> "${_OUTPUT_PATH}/index.${_FILE_EXTENSION}x"
        sed -e "s/SampleComponent/${_NAME}/g" -e "s/COMPONENT_CLASS_NAME/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" -e "s/componentClass/${CLASS_NAME}/g" -e "s/reducerName/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" -e "s/MAIN_TAG/${MAIN_TAG}/g" "${_OUTPUT_PATH}/index.${_FILE_EXTENSION}x" > "${_OUTPUT_PATH}/index-temp.${_FILE_EXTENSION}x"
        mv "${_OUTPUT_PATH}/index-temp.${_FILE_EXTENSION}x" "${_OUTPUT_PATH}/index.${_FILE_EXTENSION}x"

        touch "${_OUTPUT_PATH}/index.test.${_FILE_EXTENSION}x"
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> ${_OUTPUT_PATH}/index.test.${_FILE_EXTENSION}x && echo "" >> ${_OUTPUT_PATH}/index.test.${_FILE_EXTENSION}x`
        cat "${_ORIGIN_PATH}Component_test.${_FILE_EXTENSION}x" >> "${_OUTPUT_PATH}/index.test.${_FILE_EXTENSION}x"
        sed -e "s/ComponentName/${_NAME}/g" -e "s/COMPONENT_CLASS_NAME/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" -e "s/reducerName/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" ${_OUTPUT_PATH}/index.test.${_FILE_EXTENSION}x > ${_OUTPUT_PATH}/index.test-temp.${_FILE_EXTENSION}x
        mv "${_OUTPUT_PATH}/index.test-temp.${_FILE_EXTENSION}x" "${_OUTPUT_PATH}/index.test.${_FILE_EXTENSION}x"

        touch "${_OUTPUT_PATH}/helpers.${_FILE_EXTENSION}"
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> ${_OUTPUT_PATH}/helpers.${_FILE_EXTENSION} && echo "" >> ${_OUTPUT_PATH}/helpers.${_FILE_EXTENSION}`
        cat "${_ORIGIN_EXAMPLES_PATH}helpers.${_FILE_EXTENSION}" >> "${_OUTPUT_PATH}/helpers.${_FILE_EXTENSION}"

        touch "${_OUTPUT_PATH}/styles.scss"
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> "${_OUTPUT_PATH}/styles.scss" && echo "" >> "${_OUTPUT_PATH}/styles.scss"`
        cat "${ORIGIN_SASS_PATH}styles.scss" >> "${_OUTPUT_PATH}/styles.scss"
        sed -e "s/componentClass/${CLASS_NAME}/g" "${_OUTPUT_PATH}/styles.scss" > "${_OUTPUT_PATH}/styles-temp.scss"
        mv "${_OUTPUT_PATH}/styles-temp.scss" "${_OUTPUT_PATH}/styles.scss"

        touch "${_OUTPUT_PATH}/styles.css"
        eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> "${_OUTPUT_PATH}/styles.css" && echo "" >> "${_OUTPUT_PATH}/styles.css"`

        if [ "${_TYPE}" = "Smart" ];
        then
            touch "${_OUTPUT_PATH}/actions.${_FILE_EXTENSION}"
            eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> "${_OUTPUT_PATH}/actions.${_FILE_EXTENSION}" && echo "" >> "${_OUTPUT_PATH}/actions.${_FILE_EXTENSION}"`
            cat "${_ORIGIN_PATH}actions.${_FILE_EXTENSION}" >> "${_OUTPUT_PATH}/actions.${_FILE_EXTENSION}"
            sed -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" -e "s/sampleActionConstant/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" -e "s/reducerName/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" "${_OUTPUT_PATH}/actions.${_FILE_EXTENSION}" > "${_OUTPUT_PATH}/actions-temp.${_FILE_EXTENSION}"
            mv "${_OUTPUT_PATH}/actions-temp.${_FILE_EXTENSION}" "${_OUTPUT_PATH}/actions.${_FILE_EXTENSION}"

            touch "${_OUTPUT_PATH}/actions.test.${_FILE_EXTENSION}"
            eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> "${_OUTPUT_PATH}/actions.test.${_FILE_EXTENSION}" && echo "" >> "${_OUTPUT_PATH}/actions.test.${_FILE_EXTENSION}"`
            cat "${_ORIGIN_PATH}actions_test.${_FILE_EXTENSION}" >> "${_OUTPUT_PATH}/actions.test.${_FILE_EXTENSION}"
            sed -e "s/ComponentName/${_NAME}/g" -e "s/ComponentName/${_NAME}/g" -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" -e "s/reducerName/${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}/g" "${_OUTPUT_PATH}/actions.test.${_FILE_EXTENSION}" > "${_OUTPUT_PATH}/actions.test-temp.${_FILE_EXTENSION}"
            mv "${_OUTPUT_PATH}/actions.test-temp.${_FILE_EXTENSION}" "${_OUTPUT_PATH}/actions.test.${_FILE_EXTENSION}"

            touch "${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}"
            eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> "${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}" && echo "" >> "${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}"`
            cat "${_ORIGIN_PATH}reducer.${_FILE_EXTENSION}" >> "${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}"
            sed -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" -e "s/CONSTANTS_PATH/${CONSTANTS_IMPORT_PATH}/g" "${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}" > "${_OUTPUT_PATH}/reducer-temp.${_FILE_EXTENSION}"
            mv "${_OUTPUT_PATH}/reducer-temp.${_FILE_EXTENSION}" "${_OUTPUT_PATH}/reducer.${_FILE_EXTENSION}"

            touch "${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}"
            eval `echo \/\* $(getAutogeneratedMessage) \*\/ >> "${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}" && echo "" >> "${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}"`
            cat "${_ORIGIN_PATH}reducer_test.${_FILE_EXTENSION}" >> "${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}"
            sed -e "s/ComponentName/${_NAME}/g" -e "s/ComponentName/${_NAME}/g" -e "s/SAMPLE_ACTION_CONSTANT/${SAMPLE_ACTION_CONSTANT}/g" -e "s/CONSTANTS_PATH/${CONSTANTS_IMPORT_PATH}/g" "${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}" > "${_OUTPUT_PATH}/reducer.test-temp.${_FILE_EXTENSION}"
            mv "${_OUTPUT_PATH}/reducer.test-temp.${_FILE_EXTENSION}" "${_OUTPUT_PATH}/reducer.test.${_FILE_EXTENSION}"
            
            addReducerToFile "${_NAME}" "${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}" "container"
            addConstantToFile "${SAMPLE_ACTION_CONSTANT}" "${SAMPLE_ACTION_CONSTANT_LOWER_CAMEL_CASE}" "${_FILE_EXTENSION}"
        fi
    fi

    updateHelpersFile "${_ORIGIN_EXAMPLES_PATH}"
    printSuccessMessage "All files has been created. These are stored in '${_OUTPUT_PATH}'"
}

function deleteComponent {
    local COMPONENT_TO_DELETE=""
    local COMPONENT_AS_CONSTANT=""
    local REMOVED=false

    if [[ -z ${1} ]];
        then
        ask "Write component to delete: "
        read COMPONENT_TO_DELETE

        while [ "${COMPONENT_TO_DELETE}" = "" ];
        do
            printWarning "Cannot set an empty component name"
            ask "Please write a new component name: "
            read COMPONENT_TO_DELETE
        done;
    else
        COMPONENT_TO_DELETE=${1}
    fi

    findAndRemoveComponent "${COMPONENT_TO_DELETE}" "${OUTPUT_COMPONENTS_PATH}"
    findAndRemoveComponent "${COMPONENT_TO_DELETE}" "${OUTPUT_CONTAINERS_PATH}"
}

#######################################
# Add imported directory to constant file
# Globals:
#   ACTION_CONSTANT 1
#   ACTION_CONSTANT_LOWER_CAMEL_CASE 2
#   FILE_EXTENSION 3
# Arguments:
#   None
# Returns:
#   None
#######################################
function addConstantToFile {
    local _ACTION_CONSTANT="${1}"
    local _ACTION_CONSTANT_LOWER_CAMEL_CASE="${2}"
    local _FILE_EXTENSION="${3}"

    eval `echo "export const ${_ACTION_CONSTANT} = \""${_ACTION_CONSTANT_LOWER_CAMEL_CASE}"\";" >> "./src/constants/index.${_FILE_EXTENSION}"`
}

function updateConstantsFile {
    printNotificationMessage "Updating constants file"

    if ! [ -d "$CONSTANTS_PATH" ]; then
        mkdir "${CONSTANTS_PATH}"
        touch "${CONSTANTS_PATH}index.js"
    fi

    local FILE="${CONSTANTS_PATH}index.js"
    local TEMP_FILE="${CONSTANTS_PATH}index-temp.js"
    local TO_REMOVE=$(`echo grep -w "${1}" ${FILE}`)

    updateFile "${FILE}" "${TEMP_FILE}" "${TO_REMOVE}"

    printSuccessMessage "Constants file has been updated"
}

#######################################
# Add imported directory to reducers file
# Globals:
#   NAME 1
#   ACTION_CONSTANT_LOWER_CAMEL_CASE 2
#   TYPE 3
# Arguments:
#   None
# Returns:
#   None
#######################################
function addReducerToFile {
  local _NAME="${1}"
  local _ACTION_CONSTANT_LOWER_CAMEL_CASE="${2}"
  local _TYPE="${3}"

  printNotificationMessage "Updating reducers file"
  touch ./src/reducers/index-temp.js

  echo "// $(getAutogeneratedMessage)" >> ./src/reducers/index-temp.js

  while read LINE; do
    [[ -z ${LINE} ]] && continue

    echo "${LINE}" >> ./src/reducers/index-temp.js

    if [[ ${LINE} = "/* reducers */" ]] && [[ ${_TYPE} = "reducer" ]];
    then
      echo "import ${_NAME}Reducer from ""\"./${_NAME}/reducer""\";" >> ./src/reducers/index-temp.js
    fi

    if [[ ${LINE} = "/* containers */" ]] && [[ ${_TYPE} = "container" ]];
    then
      echo "import ${_NAME}Reducer from ""\"../containers/${_NAME}/reducer""\";" >> ./src/reducers/index-temp.js
    fi

    if [[ ${LINE} = "/* key:value */" ]]; 
    then
      echo "${_ACTION_CONSTANT_LOWER_CAMEL_CASE}Reducer: ${_NAME}Reducer," >> ./src/reducers/index-temp.js
    fi
  done < ./src/reducers/index.js

  rm -rf ./src/reducers/index.js
  mv ./src/reducers/index-temp.js ./src/reducers/index.js
  printSuccessMessage "Reducers file has been updated"
}

#######################################
# Update reducers file
# Globals:
#   NAME 1
# Arguments:
#   None
# Returns:
#   None
#######################################
function updateReducersFile {
    local _NAME="${1}"
    printNotificationMessage "Updating reducers file"

    local FILE="${REDUCERS_PATH}index.js"
    local TEMP_FILE="${REDUCERS_PATH}index-temp.js"
    local TO_REMOVE=$(`echo grep -w "${_NAME}Reducer" ${FILE}`)

    updateFile "${FILE}" "${TEMP_FILE}" "${TO_REMOVE}"

    printSuccessMessage "Reducers file has been updated"
}

function deleteReducer {
    REDUCER_TO_DELETE=""
    REDUCER_AS_CONSTANT=""
    REMOVED=false

    showAllReducers

    ask "Write reducer to delete: "
    read REDUCER_TO_DELETE

    while [ "${REDUCER_TO_DELETE}" = "" ];
    do
        printWarning "Cannot set an empty reducer name"
        ask "Please write a new reducer name: "
        read REDUCER_TO_DELETE
    done;

    REDUCER_AS_CONSTANT=$(sed -e "s/\([A-Z]\)/_\1/g" -e "s/^_//" <<< "${REDUCER_TO_DELETE}")
    REDUCER_AS_CONSTANT=$(echo ${REDUCER_AS_CONSTANT} | tr '[:lower:]' '[:upper:]')

    for REDUCER_NAME in `ls src/reducers`
    do
        if [ ${REDUCER_TO_DELETE} = ${REDUCER_NAME} ]; then
            rm -rf "src/reducers/${REDUCER_TO_DELETE}"
            REMOVED=true
            updateConstantsFile ${REDUCER_AS_CONSTANT}
            updateReducersFile ${REDUCER_TO_DELETE}
            printSuccessMessage "<${REDUCER_TO_DELETE}/> has been removed"
            deleteReducer
            askAndGo "Delete another reducer? [Y/n] " deleteReducer
        fi
    done

    if [ ${REMOVED} = false ]; then
        printError "Reducer <${REDUCER_TO_DELETE}/> not found"
        deleteReducer
    fi
}

function updateHelpersFile {
    local ORIGIN_PATH="${1}shared_helpers.js"
    local OUTPUT_PATH="${UTILS_PATH}_helpers.js"

    cp ${ORIGIN_PATH} ${OUTPUT_PATH}
    echo "// $(getAutogeneratedMessage)" | cat - ${OUTPUT_PATH} > temp && mv temp ${OUTPUT_PATH}
    printNotificationMessage "Updating helpers file"
}

function showAllReducers {
    local HAS_REDUCERS=false

    echo ${COLOR_BLUE_2}"Reducers"${RESET_COLOR}
    for REDUCER in `ls ./src/reducers`
    do
        if [ "${REDUCER}" != "index.js" ]; then
            HAS_REDUCERS=true
            echo "  |__ ${REDUCER}"
        fi
    done

    if [[ ${HAS_REDUCERS} = false ]]; then
        echo ${COLOR_GREY_1}"  No reducers has been created"${RESET_COLOR}
    fi
}

function updateFile {
    echo "// $(getAutoUpdatedMessage)" > ${2}

    cat ${1} | while read LINE;
    do
        if ! [[ ${LINE} = $(head -n 1 ${1}) ]] && ! [[ ${3} = *"${LINE}"* ]];
        then
           echo "${LINE}" >> ${2}
        fi
    done

    rm -rf ${1}
    mv ${2} ${1}
}

function showAllComponents {
    echo ${COLOR_BLUE_2}"Components: "${RESET_COLOR}
    local TOTAL_COMPONENTS="$(find ./src/components -type f -maxdepth 1 | wc -l)"
    if [[ TOTAL_COMPONENTS -eq 0 ]];
    then
        echo ${COLOR_GREY_1}"  No components has been created"${RESET_COLOR}
    else
        echo "Total: ${TOTAL_COMPONENTS} components"
        echo "----------------------------------------------------------"
        showDirectories "./src/components"
    fi

    echo ${COLOR_BLUE_2}"Containers: "${RESET_COLOR}
    local TOTAL_CONTAINERS="$(ls -l ./src/containers | wc -l)"
    if [[ TOTAL_CONTAINERS -eq 0 ]];
    then
        echo ${COLOR_GREY_1}"  No containers has been created"${RESET_COLOR}
    else
        echo "Total: ${TOTAL_CONTAINERS} containers"
        echo "----------------------------------------------------------"
        showDirectories "./src/containers"
    fi
}

function checkForAllComponents {
    HAS_COMPONENTS=false
    HAS_CONTAINERS=false
    HAS_ANY=true

    for COMPONENT in `ls ./src/components`
    do
        HAS_COMPONENTS=true
    done

    for COMPONENT in `ls ./src/containers`
    do
        HAS_CONTAINERS=true
    done

    if [[ ${HAS_COMPONENTS} = false ]] && [[ ${HAS_CONTAINERS} = false ]]; then
        HAS_ANY=false
    fi

    echo ${HAS_ANY}
}

function showDirectories {
    local TAB="${2}"
    ls ${1} | while read DIR_NAME;
    do
        local SUB_DIR_NAME="${DIR_NAME##*${1}}"
        local FULL_DIR="${1}/${DIR_NAME}"

        if [[ -d "${FULL_DIR}" ]];
        then
            echo "  ${TAB}${SUB_DIR_NAME}"
            showDirectories "${FULL_DIR}" "${TAB}   "
        fi
    done
}

function findAndRemoveComponent {
    local COMPONENT_NAME="${1}"
    local COMPONENT_PATH="${2}"

    ls ${COMPONENT_PATH} | while read COMPONENT;
    do
        local COMPONENT_FOUND="${COMPONENT##*${COMPONENT_PATH}}"
        local FULL_DIR="${COMPONENT_PATH}/${COMPONENT}"

        if [[ -d "${FULL_DIR}" ]];
        then
            if [[ ${COMPONENT_FOUND} = ${COMPONENT_NAME} ]];
            then
                found=true
                printSuccessMessage "> Found '${COMPONENT_FOUND}' at ${FULL_DIR}"

                local COMPONENT_AS_CONSTANT=$(sed -e "s/\([A-Z]\)/_\1/g" -e "s/^_//" <<< "${COMPONENT_NAME}")
                COMPONENT_AS_CONSTANT=$(echo ${COMPONENT_AS_CONSTANT} | tr '[:lower:]' '[:upper:]')

                local REMOVE_COMPONENT=false
                local TOTAL_FILES="$(find ${FULL_DIR} -type f -maxdepth 1 | wc -l)"
                local INDEX=0

                ls ${FULL_DIR} | while read FILE;
                do
                    INDEX=$(( ${INDEX} + 1 ))

                    if [[ ${FILE} = "index.js" ]] || [[ ${FILE} = "index.js" ]] || [[ ${FILE} = "index.jsx" ]];
                    then
                        REMOVE_COMPONENT=true
                    fi

                    if [[ ${INDEX} -eq ${TOTAL_FILES} ]] && [[ ${REMOVE_COMPONENT} = true ]];
                    then
                        local COMPONENT_TYPE=$(echo ${FULL_DIR}| cut -d '/' -f 3)
                        COMPONENT_TYPE=${COMPONENT_TYPE:0:$(( ${#COMPONENT_TYPE} - 1 ))}

                        rm -rf ${FULL_DIR}
                        updateConstantsFile ${COMPONENT_AS_CONSTANT}

                        if [[ ${COMPONENT_TYPE} = "container" ]];
                        then
                            updateReducersFile ${COMPONENT_NAME}
                        fi

                        printSuccessMessage "<${COMPONENT_NAME}/> has been removed"
                    fi
                done
            else
                findAndRemoveComponent "${COMPONENT_NAME}" "${FULL_DIR}"
            fi
        fi
    done
}

# TODO
function findComponent {
    _comp="dffdfdf"

    function __findComponent {
        local COMPONENT_NAME="${1}"
        local COMPONENT_PATH="${2}"
        local found=${3}

        echo "RECEIVE >> ${COMPONENT_PATH} ${3}"

        ls ${COMPONENT_PATH} | while read COMPONENT;
        do

            local COMPONENT_FOUND="${COMPONENT##*${COMPONENT_PATH}}"
            local FULL_DIR="${COMPONENT_PATH}/${COMPONENT}"

            if [[ -d "${FULL_DIR}" ]];
            then
                echo ">>> ${COMPONENT} <<<"

                 if [[ ${COMPONENT_FOUND} = ${COMPONENT_NAME} ]];
                then
                    _comp=true
                fi

                if [[ ${COMPONENT_FOUND} = ${COMPONENT_NAME} ]];
                then
                    printSuccessMessage "> Found '${COMPONENT_FOUND}' at ${FULL_DIR}"

                    local COMPONENT_AS_CONSTANT=$(sed -e "s/\([A-Z]\)/_\1/g" -e "s/^_//" <<< "${COMPONENT_NAME}")
                    COMPONENT_AS_CONSTANT=$(echo ${COMPONENT_AS_CONSTANT} | tr '[:lower:]' '[:upper:]')

                    local REMOVE_COMPONENT=false
                    local TOTAL_FILES="$(find ${FULL_DIR} -type f -maxdepth 1 | wc -l)"
                    local INDEX=0

                    ls ${FULL_DIR} | while read FILE;
                    do
                        INDEX=$(( ${INDEX} + 1 ))

                        if [[ ${FILE} = "index.js" ]];
                        then
                            REMOVE_COMPONENT=true
                        fi

                        if [[ ${INDEX} -eq ${TOTAL_FILES} ]] && [[ ${REMOVE_COMPONENT} = true ]];
                        then
                            local COMPONENT_TYPE=$(echo ${FULL_DIR}| cut -d '/' -f 3)
                            COMPONENT_TYPE=${COMPONENT_TYPE:0:$(( ${#COMPONENT_TYPE} - 1 ))}
                            printNotificationMessage "> Remove '${COMPONENT_FOUND}' as ${COMPONENT_TYPE}"

                            #rm -rf ${FULL_DIR}
                            #updateConstantsFile ${COMPONENT_AS_CONSTANT}

                            if [[ ${COMPONENT_TYPE} = "container" ]];
                            then
                                #updateReducersFile ${COMPONENT_NAME}
                                :
                            fi

                            printSuccessMessage "<${COMPONENT_NAME}/> has been removed"
                        fi
                    done
                else
                    echo "SEND >> ${COMPONENT_NAME} ${FULL_DIR} ${found}"
                    __findComponent "${COMPONENT_NAME}" "${FULL_DIR}" "${found}"
                fi
            fi
        done
    }

    __findComponent "${1}" "${2}"
    echo "__findComponent: ${_comp}"
}

function initReactProgram {
    source "$( dirname "${BASH_SOURCE[0]}" )/.react-cli.config"

    echo ${BACKGROUND_COLOR_ORANGE_2}${COLOR_BLACK_1}"  REACT                               "${RESET_COLOR}
    echo ${COLOR_ORANGE_2}"[1] Create component"
    echo "[2] Create reducer"
    echo "[3] Show all components & reducers"
    echo "[4] Update helpers file"
    echo ${COLOR_RED_1}"[5] Remove component"${APPLICATION_COLOR}
    echo ${COLOR_RED_1}"[6] Remove reducer"${APPLICATION_COLOR}
    echo ${RESET_COLOR}"[0]  Back to main menu"

    ask ${COLOR_PINK_1}"Select task: "${RESET_COLOR}
    read TASK

    case "$TASK" in
    '98')
        # TODO Setup config file for React and add to ./.react-cli.config
        # TODO Check if the file exists
    ;;
    '99')
        # TODO change option number
        setupBaseApp
    ;;
    '1')
        createComponent
    ;;
    '2')
        createReducer
    ;;
    '3')
        showAllComponents
        showAllReducers
    ;;
    '4')
        # TODO review this function
        #updateHelpersFile
    ;;
    '5')
        deleteComponent
    ;;
    '6')
        deleteReducer
    ;;
    '0')
        ${1}
    ;;
    *)
        taskNotAvailable initReactProgram
    ;;
    esac
}