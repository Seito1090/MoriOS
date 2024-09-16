#! /bin/bash

CODE_VERSION=$1
USER=$2

input="../../configs/vscode/extensions_ids.txt"
while IFS= read -r line
do
  extensions+=("$line")
  echo "- $line"
done < "$input"

# Install the packages
for ext in "${extensions[@]}"
do
  sudo -u "$USER" bash -c "$CODE_VERSION --install-extension $ext"
done

echo $CODE_VERSION
