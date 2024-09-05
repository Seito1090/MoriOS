#! /bin/bash
echo "List of packages that will be installed on the system:"

# Loop over the packages in the file "input" and put them in an array

input="packges_list.txt"
while IFS= read -r line
do
  packages+=("$line")
  echo "- $line"
done < "$input"

# Install the packages
for pkg in "${packages[@]}"
do
  sudo dnf install -y $pkg
done