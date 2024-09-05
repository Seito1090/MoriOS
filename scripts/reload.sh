#! /bin/bash
#TODO : make it differentiate the versions ! (the most important there...) here it assumes no compatibility issues :( 
# Get the old packages from the backup
backup="backup/oldConfig.txt"
current="configs/config.txt"

while IFS= read -r pkg 
do
  broken+=("$pkg")
done < "$current" 

while IFS= read -r line
do 
  safe+=("$line")
done < "$backup"

for pkg in "${safe[@]}"
do 
  sudo dnf install -y $pkg
done 

# Compare the 2 package lists and remove the ones that are not in the 
# old one 
for pkg in "${broken[@]}"
do
  if [[ ! " ${safe[@]} " =~ " ${pkg} " ]]; then
    sudo dnf remove -y $pkg
  fi
done

# Set the current config to the backup
cp $backup $current

echo "test of c code " 

sudo dnf list installed | grep hyprland | ./scripts/version
