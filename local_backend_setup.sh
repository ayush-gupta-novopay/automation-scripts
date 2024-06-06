#!/bin/bash

echo "Enter organisation/user name"
read userName

echo "Enter branch"
read branchName

echo "Enter local path for git repos"
read gitRepoPath

doSetup() {

    local gitRepoName=$1

    cd ${gitRepoPath}
    git clone "https://github.com/${userName}/${gitRepoName}.git"

    cd ${gitRepoName}/

    if [ "$userName" != "khoslalabs" ]; then
        git remote add upstream "https://github.com/khoslalabs/${gitRepoName}.git"
        git pull upstream ${branchName}
    else
        git pull origin
    fi

    git checkout ${branchName}
    if [ "$gitRepoName" == "novopay-platform-initial-setup" ]; then
        cd flyway/
        sh localhost.sh
        echo "==============================================================================="
        return
    fi

    if [ "$gitRepoName" == "novopay-platform-lib" ]; then
        sh build_all.sh
        echo "==============================================================================="
        return
    fi
    
    sh gradlew clean build -x test

    echo "==============================================================================="
    echo "==============================================================================="

}
doSetup "novopay-platform-initial-setup"
doSetup "novopay-platform-lib"

doSetup "novopay-platform-actor"
doSetup "novopay-platform-accounting-v2"
doSetup "novopay-platform-authorization"
doSetup "novopay-platform-api-gateway"
doSetup "novopay-platform-approval"
doSetup "novopay-platform-masterdata-management"
doSetup "novopay-platform-notifications"
doSetup "novopay-platform-dms"
doSetup "novopay-platform-task"
doSetup "novopay-platform-audit"
doSetup "novopay-platform-batch"
doSetup "novopay-platform-payments"
doSetup "novopay-platform-consents"

doSetup "novopay-mfi-los"
doSetup "trustt-platform-reporting"
