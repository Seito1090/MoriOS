#! /bin/bash

declare PACKAGE_MANAGER="dnf"
declare INSTALL_TYPE="full"
declare CUSTOM="true"
declare VERSION="Code - Insiders"

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root since we need to install things :) Please try again with sudo or as root."
  exit 1
fi

USER_HOME=$(eval echo "~$SUDO_USER") # Yoink the user's home dir for the future

if [ -n "$1" ] && [ "$1" == "--partial" ]; then
  INSTALL_TYPE="partial"
  echo "Hi"
fi

echo "Package manager is :" $PACKAGE_MANAGER

echo "Install type is :" $INSTALL_TYPE

# Installing vscode insiders / checking if it is already there
echo "Checking for vscode"

FOUND_CODE=$(sudo $PACKAGE_MANAGER list installed | grep code*)

if [ -n "$FOUND_CODE" ]; then
  echo "VSCode installed, we don't have to download it"
  # Check if it is insiders or the normal version
  TEMP=$(sudo $PACKAGE_MANAGER list installed | grep code-insiders)
  if [ -z "TEMP" ]; then
    VERSION="Code"
  fi
else
  echo "VSCode not found, you either do not have it or didn't install it through the package manager"
  echo "Installing it now..."
  sudo $PACKAGE_MANAGER install code-insiders -y
fi

# Installing all the custom settings and extensions if wanted
echo "Do you want to install the custom settings and extensions for it ? [Y/n]"

read input_custom

if [ "$input_custom" != "n" ] && [ "$input_custom" != "N" ]; then
  #./get_settings.sh # TODO, this thing <-, it installs the custom extensions and gets the config stored on git
else
  CUSTOM="false"
  if [ -n "$FOUND_CODE" ]; then
    echo "VSCode already installed"
  else
    sudo $PACKAGE_MANAGER install code-insiders -y
  fi
fi

# Part where settings json is downloaded and yeeted to the correct place
wget https://raw.githubusercontent.com/Seito1090/MoriOS/main/configs/vscode/settings.json
echo
CHECK=$(ls -a | grep settings.json)
if [ -n "$CHECK" ]; then
  echo "Applying the settings in :" $USER_HOME/.config/$VERSION/User
  mv -f settings.json  "$USER_HOME/.config/$VERSION/User/"

  # Check if the mv command was successful
  if [ $? -eq 0 ]; then
      echo "Applied successfully."
  else
      echo "Check if you have a vscode dir int your .config"
  fi
fi

echo "hi"
