#!/usr/bin/env bash

# Check for required commands
required=(awk grep lynx wget git ssh-agent ssh-add); missing=()
for command in ${required[@]}; do
    hash $command 2>/dev/null || missing+=($command)
done
if (( ${#missing[@]} > 0 )); then
    echo "[FATAL] could not find command(s): ${missing[@]}. Exiting!"
    exit 1
fi

# Variables
sourcepath="https://www.bevy.be/bevyfiles/qatarpremium.xml"
local_destination="."

# Download the file
echo -n "[GET] Downloading qatarpremium.xml... "
wget -q -P $local_destination $sourcepath
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to download qatarpremium.xml"
    exit 1
fi
echo "DONE"

# GitHub repository details
repo_url="git@github.com:Saiedf/Test.git"
repo_dir="Test"
file_path="files/qatarpremium.xml"

# Ensure SSH key is added
ssh_key="$HOME/.ssh/id_rsa"
if [ ! -f "$ssh_key" ]; then
    echo "[FATAL] SSH key not found at $ssh_key. Exiting!"
    exit 1
fi
eval "$(ssh-agent -s)"
ssh-add $ssh_key

# Clone the GitHub repository
echo "[GIT] Cloning the repository..."
git clone $repo_url
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to clone the repository"
    exit 1
fi

# Move the downloaded file to the appropriate directory in the cloned repo
mv $local_destination/qatarpremium.xml $repo_dir/$file_path
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to move qatarpremium.xml to the repository directory"
    exit 1
fi

# Change to the repository directory
cd $repo_dir

# Add, commit, and push the file
echo "[GIT] Adding, committing, and pushing the file..."
git add $file_path
git commit -m "Add qatarpremium.xml"
git push origin main
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to push the file to the repository"
    exit 1
fi
