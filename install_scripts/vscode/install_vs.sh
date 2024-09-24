#! /bin/bash
# Script to intall vscode with all its extensions that I like :)

declare -A osInfo;
declare VERSION="Code - Insiders"
declare TERMINAL_CALL="code-insiders"

# Be sure to run as sudo (installing things), tho it might be possible to avoid it #TODO
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root since we need to install things :) Please try again with sudo or as root."
  exit 1
fi

USER_HOME=$(eval echo "~$SUDO_USER") # Yoink the user's home dir for the future

# Determine the package manager used
osInfo[/etc/arch-release]=pacman
osInfo[/etc/redhat-release]=dnf
osInfo[/etc/debian_version]=apt-get
for f in ${!osInfo[@]}
do
  if [[ -f $f ]];then
    PACKAGE_MANAGER=${osInfo[$f]}
  fi
done

case $PACKAGE_MANAGER in
  dnf)
  echo "you've got a fedora based distro huh"
  PACK_INSTALL="sudo dnf install"
  PACK_LIST="sudo dnf list installed"
  ;;
  pacman)
  echo "you use arch btw"
  PACK_INSTALL="sudo pacman -S"
  PACK_LIST="sudo pacman -Q"
  ;;
  apt)
  echo "classic, you ve never been wrong before huh"
  PACK_INSTALL="sudo apt-get install"
  PACK_LIST="sudo apt list --installed"
  ;;
  *)
  echo "what the actual f*?"
  PACK_INSTALL=none
  PACK_LIST=none
  exit 1
  ;;
esac

# Installing vscode / checking if it is already there
echo "Checking for vscode"

FOUND_CODE=$($PACK_LIST | grep @code)

if [ -n "$FOUND_CODE" ]; then
  echo "VSCode installed, we don't have to download it"
  # Check if it is insiders or the normal version
  TEMP=$($PACK_LIST | grep code-insiders)
  if [ -z "TEMP" ]; then
    VERSION="Code"
    TERMINAL_CALL="code"
  fi
else
  echo "VSCode not found, you either do not have it or didn't install it through the package manager"
  echo "Installing it now..."
  sudo $PACK_INSTALL code-insiders -y
fi

# Installing all the custom settings and extensions if wanted
echo "Do you want to install the custom settings and extensions for it ? [Y/n]"

read input_custom

if [ "$input_custom" != "n" ] && [ "$input_custom" != "N" ]; then
  ./install_scripts/vscode/get_settings.sh $TERMINAL_CALL $SUDO_USER
else
  exit 0
fi

# Part where settings json is downloaded and yeeted to the correct place
wget https://raw.githubusercontent.com/Seito1090/MoriOS/main/configs/vscode/settings.json > /dev/null 2>&1

CHECK=$(ls -a | grep settings.json)

if [ -n "$CHECK" ]; then
  echo "Applying the settings in :" $USER_HOME/.config/$VERSION/User
  mv -f settings.json  "$USER_HOME/.config/$VERSION/User/"

  # Check if the mv command was successful
  if [ $? -eq 0 ]; then
      echo "Applied successfully."
  else
      echo "Check if you have a vscode dir in your .config"
  fi
fi


# Update the permissions to the vscode dir (for css modifications)
sudo chown -R $SUDO_USER "$(which $TERMINAL_CALL)"
sudo chown -R $SUDO_USER /usr/share/$TERMINAL_CALL

mkdir -p $USER_HOME/.config/vscode_settings/css_config/
cp configs/vscode/css/pretty_bar.css $USER_HOME/.config/vscode_settings/css_config/

echo "Done."
echo "If the theme did not apply on vscode, press F1 and reload css and js."
echo "If promped, restart Vscode, if it complains to be corrupted, it can be ignored."
