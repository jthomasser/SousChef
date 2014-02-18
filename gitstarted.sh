#!/bin/sh

#
# Detirmine version, if its new than 1.7.10 user can use https for 
# github accessing repo.
#
#
VERSION=`git --version | awk '{print $3}'`
MAJOR=`echo $VERSION | awk -F. '{print $1}' ` 
MINOR=`echo $VERSION | awk -F. '{print $2}' `
MICRO=`echo $VERSION | awk -F. '{print $3}' `
if [ $MAJOR -ge 1 -a $MINOR -ge 7 -a $MICRO -ge 10 ] ; then
	echo version OK
else
     	echo "You need version 1.7.10 of GIT or better, this allows https access to github"
     	echo "Exiting...."
     	exit 1
fi

echo "Setting up a git repo using local directory"
echo "Updating git global defintions. These can be found in ~/.gitconfig "

#
# see: https://help.github.com/articles/set-up-git#platform-linux
#
# Sets the default name for git to use when you commit
#
# git config --get user.name
#
USERNAME=`git config --get user.name`
if [ "$USERNAME" != "" ] ; then 
	echo Using username  "$USERNAME"
	
else

	echo -n "Enter your Name (First Last): "
	read USERNAME
	git config --global user.name "$USERNAME"

fi
#
# Sets the default email for git to use when you commit
#
#
# git config --get user.email
#
EMAIL=`git config --get user.email`
if [ "$EMAIL" != "" ] ; then 
	echo Using email "$EMAIL"
else
	echo -n "Enter email: "
	read EMAIL
	git config --global user.email "$EMAIL"
fi
#
# Set git to use the credential memory cache
#
git config --global credential.helper cache
#
# Set the cache to timeout after 1 hour (setting is in seconds)
#
git config --global credential.helper 'cache --timeout=3600'

#
# Create a github Repo
# See https://help.github.com/articles/create-a-repo
#

REPONAME=`basename $PWD` 
echo "Create repo using current foldername, reponame will be $REPONAME"

echo -n "Go to to github site and create a repo, press <return> when done: "
read answer

RESPONSE=no
while [ "$RESPONSE" != "yes" ] ; do 
	echo -n "Enter RepoName: "
	read REPONAME

	echo We will be accessing github at https://github.com/$USERNAME/"$REPONAME".git
	echo -n "OK? (yes|no) : "
	read RESPONSE
done


git init
touch README
git commit -m "First Commit"
git add README
git remote add origin https://github.com/"$USERNAME"/"$REPONAME".git
git push origin master

