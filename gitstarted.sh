#!/bin/sh

echo "Setting up a git repo"
echo ""
echo "Updating git global defintions. These can be found in ~/.gitconfig "

#
# see: https://help.github.com/articles/set-up-git#platform-linux
#
# Sets the default name for git to use when you commit
#
echo -n "Enter username: "
read USERNAME
git config --global user.name "$USERNAME"
#
# Sets the default email for git to use when you commit
#
echo -n "Enter email: "
read EMAIL
git config --global user.email "$EMAIL"
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
echo "create repo using current foldername, reponame will be $REPONAME"
read answer

echo -n "Go to to github site and create a repo, press <return> when done: "
read answer

RESPONSE=no
while [ "$RESPONSE" != "yes" ] ; do 

	echo -n "Enter github username: "
	read USERNAME

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

