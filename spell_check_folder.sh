#!/bin/bash

# A script that asks a user for a folder and spell checks every file in that folder.

# Function to spell check a file
spell_check_file(){
    # Prompt the user for a folder
    read -p "Enter a folder name: " folder

    # Check if the folder exists
    if [ ! -d "$folder" ]
    then
        echo "Folder does not exist."
        exit 9999
    fi

    echo "Spell checking file..."

    # Iterate over files in the folder
    for file in $folder/*
    do     
    # Use the spell command to spell check a file
        spell -on $file
    done
}


spell_check_file
