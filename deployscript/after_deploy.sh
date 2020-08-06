#!/bin/bash
#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================

# md5sum tool
wget -c https://github.com/ferion11/libsutil/releases/download/md5sum_util_v0.1/md5sum_util.sh
bash md5sum_util.sh result

# uploadtool
wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh

# publish
if [[ ("$TRAVIS_BRANCH" != "$RELEASE_BRANCH" && "$TRAVIS_BRANCH" != "$TRAVIS_TAG") || "$TRAVIS_EVENT_TYPE" != "push" ]]; then
	echo 'Publishing release to GitHub...'
	export UPLOADTOOL_SUFFIX="$TRAVIS_BRANCH"
	export UPLOADTOOL_BODY="Instructions on using the AppImage can be found [here](https://github.com/${TRAVIS_REPO_SLUG}/blob/master/README.md)\n\nThis is the ***$UPLOADTOOL_SUFFIX experimental build*** for testing new features.\n\nTravis CI build log: $TRAVIS_BUILD_WEB_URL"
	bash upload.sh result/*
elif [[ "$TRAVIS_BRANCH" != "$TRAVIS_TAG" ]]; then
	echo 'Publishing release to GitHub...'
	export UPLOADTOOL_BODY="Instructions on using the AppImage can be found [here](https://github.com/${TRAVIS_REPO_SLUG}/blob/master/README.md)\n\nThis is the ***latest development build***.\n\nTravis CI build log: $TRAVIS_BUILD_WEB_URL"
	bash upload.sh result/*
else
	echo 'Publishing release to GitHub...'
	export UPLOADTOOL_BODY="Instructions on using the AppImage can be found [here](https://github.com/${TRAVIS_REPO_SLUG}/blob/master/README.md)\n\nThis is the ***release $TRAVIS_TAG stable build***.\n\nTravis CI build log: $TRAVIS_BUILD_WEB_URL"
	bash upload.sh result/*
fi
