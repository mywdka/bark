#!/usr/bin/env bash

DELIMITER="################################################################"
PYTHON_CMD="python3"
FIRST_LAUNCH=0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VENV_DIR=${SCRIPT_DIR}/venv


if [[ -z "${VIRTUAL_ENV}" ]];
then
    printf "\n%s\n" "${delimiter}"
    printf "Create and activate python venv"
    printf "\n%s\n" "${delimiter}"

    if [[ ! -d "${VENV_DIR}" ]]
    then
        "${PYTHON_CMD}" -m venv "${VENV_DIR}"
        FIRST_LAUNCH=1
    fi
    # shellcheck source=/dev/null
    if [[ -f "${VENV_DIR}"/bin/activate ]]
    then
        source "${VENV_DIR}"/bin/activate
    else
        printf "\n%s\n" "${delimiter}"
        printf "\e[1m\e[31mERROR: Cannot activate python venv, aborting...\e[0m"
        printf "\n%s\n" "${delimiter}"
        exit 1
    fi
else
    printf "\n%s\n" "${delimiter}"
    printf "python venv already activate: ${VIRTUAL_ENV}"
    printf "\n%s\n" "${delimiter}"
fi


if [[ "$FIRST_LAUNCH" == 1 ]]
then
    pip install -r ${SCRIPT_DIR}/requirements-pip.txt
fi

printf "\n%s\n" "${delimiter}"
printf "Launching bark_webui.py..."
printf "\n%s\n" "${delimiter}"

# Creates desktop icon for the user
if [ ! -e "~/.local/share/applications/bark.desktop" ]; then
    cat > ~/.local/share/applications/bark.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Bark
Comment=Bark is a generative AI model to generate voices from text.
Type=Application
Terminal=true
Icon=${SCRIPT_DIR}/app-icon.png
Exec=${SCRIPT_DIR}/webui.sh
EOF
fi

# yea yea make a loop
if [ ! -e "~/Desktop/bark.desktop" ]; then
    cat > ~/Desktop/bark.desktop << EOF
[Desktop Entry]
Version=1.0
Name=Bark
Comment=Bark is a generative AI model to generate voices from text.
Type=Application
Terminal=true
Icon=${SCRIPT_DIR}/app-icon.png
Exec=${SCRIPT_DIR}/webui.sh
EOF
fi

cd $SCRIPT_DIR
"$PYTHON_CMD" bark_webui.py