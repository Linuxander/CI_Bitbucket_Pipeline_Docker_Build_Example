#!/bin/bash

#CONFIG
USER=""
REPO=""
USERNAME="Pipeline User"
EMAIL=""

major() {
if IFS=. read -r major rest <version.txt || [ -n "$major" ]; then
  echo "$((major + 1)).0.0.$1" >"version.txt"
else
  echo "ERROR: Unable to read version number from version.txt" >&2
  exit 1
fi
}

minor() {
if IFS=. read -r major minor patch build <version.txt || [ -n "$major" ]; then
  echo "$major.$((minor + 1)).0.$1" >"version.txt"
else
  echo "ERROR: Unable to read version number from version.txt" >&2
  exit 1
fi
}

patch() {
if IFS=. read -r major minor patch build <version.txt || [ -n "$major" ]; then
  echo "$major.$minor.$((patch + 1)).$1" >"version.txt"
else
  echo "ERROR: Unable to read version number from version.txt" >&2
  exit 1
fi
}

build() {
if IFS=. read -r major minor patch build <version.txt || [ -n "$major" ]; then
  echo "$major.$minor.$patch.$1" >"version.txt"
else
  echo "ERROR: Unable to read version number from version.txt" >&2
  exit 1
fi
}

update() {
echo "New version = $(<version.txt)"
git config --global push.default simple
git remote set-url origin git@bitbucket.org:${1}/${USER}/${REPO}.git
git config user.name $USERNAME
git config user.email $EMAIL
git config -l
git add version.txt
git commit -m "[skip CI]"
git push
}

case "$1" in
  major)
    major $2
    update $3
    ;;
  minor)
    minor $2 
    update $3
    ;;
  patch)
    patch $2
    update $3
    ;;
  build)
    build $2
    update $3
    ;;
  *)
    echo "Usage: bash version.sh {major|minor|patch|build} build_number bb_auth_string"
    exit 1
esac
exit 0