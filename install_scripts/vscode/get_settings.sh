#! /bin/bash

CODE_VERSION=$1
USER=$2
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

input="configs/vscode/extensions_ids.txt"
while IFS= read -r line
do
  extensions+=("$line")
done < "$input"

# Install the packages
for ext in "${extensions[@]}"
do
  sudo -u "$USER" bash -c "$CODE_VERSION --install-extension $ext" > /dev/null 2>&1

  # Check if the extension was installed successfully
  if sudo -u "$USER" bash -c "$CODE_VERSION --list-extensions" | grep -q "$ext"; then
    echo -e "- '$ext' : ${GREEN}OK.${NC}"
  else
    echo -e "- '$ext' : ${RED}ERROR.${NC}"
  fi
done

