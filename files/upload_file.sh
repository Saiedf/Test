#!/bin/bash

# Define variables
FILE_URL="https://www.bevy.be/bevyfiles/qatarpremium.xml"
FILE_NAME="qatarpremium.xml"
REPO_URL="https://github.com/Saiedf/Test.git"
REPO_DIR="Test"
BRANCH="main"
TARGET_DIR="files"

# Download the file
curl -o $FILE_NAME $FILE_URL

# Clone the GitHub repository
git clone $REPO_URL

# Navigate to the repository directory
cd $REPO_DIR

# Create the target directory if it doesn't exist
mkdir -p $TARGET_DIR

# Move the downloaded file to the target directory
mv ../$FILE_NAME $TARGET_DIR/

# Add the file to the repository
git add $TARGET_DIR/$FILE_NAME

# Commit the changes
git commit -m "Add downloaded qatarpremium.xml file"

# Push the changes to the repository
git push origin $BRANCH

# Clean up
cd ..
rm -rf $REPO_DIR