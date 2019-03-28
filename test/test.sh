#!/bin/bash
user=${1:-test}
path_home_user=${2:-/home/test}

docker run --rm --user $user test-packer packer --version

retour=$?

if [ $retour == 0 ]; then
  echo "[SUCCESS]"
else
  echo "[FAILED]"
  exit $retour
fi

res=`docker run --user $user -e path_scripts=$path_home_user/scripts --rm test-packer /bin/bash -c 'for folder in $(ls $path_scripts); do cd $path_scripts/$folder && pwd && for file in $(ls *.json); do echo $file && packer validate *.json;done ; done'`

if [[ "$res" =~ "error" ]] || [[ -z $res ]]; then
  echo "[FAILED] Scripts"
  echo $res
  exit 1
else
  echo "[SUCCESS] Scripts"
fi

