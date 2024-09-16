#! /bin/bash

LOCATION="/usr/share/code-insiders/resources/app/out/vs/code/electron-sandbox/"
ls -la $LOCATION
LINE=$(ls -la $LOCATION | grep "workbench")
FILENAME=$(echo "$LINE" | awk '{print $NF}')
echo "Filename: $FILENAME"

if [ -w "$FILENAME" ]; then
    echo "The file '$FILENAME' is writable."
else
    echo "The file '$FILENAME' is not writable."
    #sudo chown -R $USER:$USER $LOCATION"workbench"
    LINE=$(ls -la $LOCATION | grep $USER | grep css)
    echo "$LINE"
fi
