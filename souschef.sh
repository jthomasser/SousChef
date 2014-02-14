#!/bin/sh

if [ "`whoami`" != "root" ] ; then
	echo "Need to run as root. Exiting."
	exit 1
else
	echo "running as root"
fi

install() {
	rpm -q chef
	if [ $? -eq 1 ] ; then 
		echo -n "Installing chef from OpsCode site: "
		curl -L https://www.opscode.com/chef/install.sh | bash > /dev/null 2>&1
		echo "done."
	else
		echo "chef already installed."
	fi
}

updateprofile() {
	grep "/opt/chef" ~/.bash_profile > /dev/null 
	if [ $? -eq 0 ] ; then
		echo "profile already updated"
	else
		echo "Updating Bash profile"
		echo 'export PATH="/opt/chef/embedded/bin:$PATH"' >> ~/.bash_profile
	fi
		
}

chefrepo() {
	if [ -d chef-repo ] ; then 
		echo chef-repo already exists
		return
	fi
	wget -nv http://github.com/opscode/chef-repo/tarball/master
	tar -zxf master ; rm master
	mv opscode-chef-repo* chef-repo
}
	
inrepo() {
	string=`pwd` 
	if [ `echo $string | grep -c "chef-repo$"` -eq 0 ] ; then 
		return 1
	else 
		return 0
	fi
}

getcookbook() {
	cookbook=$1
	if [ ! -f cookbooks ] ; then
		mkdir cookbooks
		echo made cookbooks directory
	fi
	#
	# check if cookbook exists
	#
	echo knife cookbook site download $cookbook
	echo mv "$cookbook"*gz cookbooks 
	echo "(cd cooksbooks ; tar -zxf "$cookbook"*gz ; /bin/rm "$cookbook"*gz )"
}

setknifecookbooks () {
	knifeconfig=.chef/knife.rb
	if [ -d .chef ] ; then
		echo .chef already exists
	else
		mkdir .chef
	fi
	if [ -f $knifeconfig ] ; then 
		echo $knifeconfig already exists
	else
		echo "cookbook_path [ '`pwd`/cookbooks' ]" > $knifeconfig
		echo $knifeconfig created.
	fi
}

	
remove() {
	rpm -e chef
}


case "$1" in
install)
	install
	updateprofile
	RETVAL=0
	;;
remove)
	remove
	RETVAL=0
	;;
chefrepo)
	chefrepo
	RETVAL=0
	;;
listbooks)
	knife cookbook site list
	RETVAL=0
	;;
setknifecookbooks)
	inrepo
	if [ $? -eq 0 ] ; then
		setknifecookbooks
		RETVAL=$?
	else
		echo not in chef-repo
		RETVAL=1
	fi
	;;
getcookbook)
	inrepo
	if [ $? -eq 0 ] ; then
		getcookbook $2
		RETVAL=$?
	else
		echo not in chef-repo
		RETVAL=1
	fi
	RETVAL=0
	;;
*)
	echo "Usage: $0 ({install|remove|chefrepo|listbooks|setknifecookbooks}|getcookbook args)"
	RETVAL=2

esac

exit $RETVAL
