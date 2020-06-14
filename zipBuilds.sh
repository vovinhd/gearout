#! /bin/bash

function zipFolder {
  FOLDER=$1
  NAME="GearOut.${FOLDER}.zip"
  echo "Creating archive ${NAME} for ${FOLDER}" 
  zip -r $NAME $FOLDER
}

cd build
for D in *;
do [ -d "${D}" ] && zipFolder $D;
done

