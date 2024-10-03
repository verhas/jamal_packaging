#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"

VERSION=`cat VERSION`
export VERSION

echo "Version=$VERSION"
wget https://repo.maven.apache.org/maven2/com/javax0/jamal/jamal-cmd/${VERSION}/jamal-cmd-${VERSION}-distribution.zip
mkdir -p target/JARS
rm -rf target/JARS/*
unzip jamal-cmd-${VERSION}-distribution.zip -d target/JARS

# Function to create package based on the operating system
create_package() {
    local INSTALLER_TYPE=$1
    jpackage --input target/JARS \
        --name jamal \
        --app-version ${VERSION} \
        --main-jar jamal-cmd-${VERSION}.jar \
        --main-class javax0.jamal.cmd.JamalMain \
        --type $INSTALLER_TYPE \
        --dest output \
        --java-options -Xmx2048m \
        --resource-dir packaging-resources
}

# Detect the operating system and create appropriate package
case "$(uname -s)" in
    Linux*)
        create_package deb
        ;;
    Darwin*)
        create_package pkg
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac
