#!/bin/sh

pylint $(git ls-files 'api/**/*.py')

if [ $? -ne 0 ]; then
    echo "Python lint tests are failing"
    exit 1
fi

cd app
flutter analyze

if [ $? -ne 0 ]; then
    echo "Flutter analyze is failing"
    exit 1
fi
