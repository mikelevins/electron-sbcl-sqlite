#!/bin/sh

sbcl --no-userinit --load lisp/electron-sbcl-sqlite.asd --eval "(cl-user::buildapp)"

# Package
mv ./lispapp ./lispapp.exe
npm i
electron-packager --overwrite . $APP_NAME
