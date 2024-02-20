#!/bin/bash

ver="version: "
project="name: "

file_name=""

function test() {
    flutter test test/main.dart
}

function readFileName() {
    while read line
    do

    if [[ $line == *$ver* ]]; then
      ver=${line//$ver/""}
    fi

    if [[ $line == *$project* ]]; then
      project=${line//$project/""}
    fi

    done < 'pubspec.yaml'

    file_name=$project-$ver
}

function build() {
    flutter clean
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
    flutter build web --web-renderer html --release
}

function zipFile() {
    cd build

    zip -r $file_name.zip web/

    open .
}

test
readFileName
build
zipFile