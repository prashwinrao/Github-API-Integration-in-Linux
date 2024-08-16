#!/bin/bash

##########################
# Author: Ashwin
# Date: 17-08-2024
# Version: v1
# This script uses Github api and print how many users are present in the project
# #########################
#

# For debugging purpose
#set -x -> Uncomment this line to enable debugging
set -e # It exits the script if any statement returns a non-true return value

# Github API URL
API_URL="https://api.github.com"

# Github Username and Personal Access Token, as they are confidential I've stored in variable and exported it as a environmental variable make sure you generate the token in your github account
USERNAME=$username
TOKEN=$token

#User and Repository Information
REPO_OWNER=$1
REPO_NAME=$2

#Function to make a Get request to the github api
function github_api_get {
        local endpoint="$1"
        local url="${API_URL}/${endpoint}"

        # send a GET request to the Github API with authentication
        curl -s -u "${USERNAME}:${TOKEN}" "$url" # -s flag is used to silent the curl output and -u flag is used to pass the username and token
}

# function to list users with read access to the repository
function list_users_with_read_access {
        local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

        #Fetch the list of collaborators on the repository
        collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')" # jq is a command-line JSON processor, it is used to parse the JSON response from the Github API and extract the required information.

        #Display the list of collaborators on the repository
        if [[ -z "$collaborators" ]]; then  # -z flag is used to check if the variable is empty
                echo " No users with read accesss  found for ${REPO_OWNER}/${REPO_NAME}."
        else
                echo " User with read access to ${REPO_OWNER}/${REPO_NAME}."
                echo "$collaborators"
        fi
}

#Main Script

echo "listin users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access